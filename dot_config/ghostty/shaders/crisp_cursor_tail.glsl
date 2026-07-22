// crisp_cursor_tail_v3.glsl
//
// A deliberately crisp Ghostty cursor trail:
// - no blur
// - no bloom or additive blending
// - the real cursor is never enlarged
// - several same-size cursor silhouettes fade behind it
//
// Requires Ghostty 1.3.0 or newer.

const float DURATION = 0.200;

// Strong enough to be clearly visible without additive glow.
const float MAX_OPACITY = 0.80;

const int TRAIL_COPIES = 13;

// Maximum trail length in approximate cursor-cell lengths.
const float MAX_TRAIL_CELLS = 3.5;

// Ignore tiny sub-cell position changes.
const float MIN_MOVE_CELLS = 0.20;

// Ghostty cannot tell the shader whether a move came from typing or navigation.
// Suppressing one-cell horizontal advances is the dependable approximation.
const bool SUPPRESS_SINGLE_CELL_HORIZONTAL = true;
const float CELL_TOLERANCE = 0.20;

// Suppress the large last-column -> first-column jump produced by line wrap.
const float WRAP_MIN_HORIZONTAL_CELLS = 4.0;

// Do not animate stale previous/current cursor state immediately after focus is
// restored. This also covers delayed frames from an unfocused surface.
const float REFOCUS_GUARD_TIME = 0.060;

// Higher values make the far end fade more strongly.
const float SPATIAL_FADE_POWER = 0.65;

// false: animate horizontal, vertical, and diagonal movement.
// true: only animate left/right movement.
const bool HORIZONTAL_ONLY = false;

vec3 srgbToLinear(vec3 c) {
    return mix(
        c / 12.92,
        pow((c + 0.055) / 1.055, vec3(2.4)),
        step(vec3(0.04045), c)
    );
}

// Convert pixel coordinates to the normalized coordinate system used by the
// known-working Ghostty cursor shaders. Positions use isPosition=1.0;
// dimensions use isPosition=0.0.
vec2 toNormalized(vec2 value, float isPosition) {
    return (value * 2.0 - iResolution.xy * isPosition) / iResolution.y;
}

float rectangleSdf(vec2 point, vec2 center, vec2 halfSize) {
    vec2 d = abs(point - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float rectangleMask(vec2 point, vec2 center, vec2 halfSize) {
    // Hard edge: intentionally no antialiasing or blur.
    return step(rectangleSdf(point, center, halfSize), 0.0);
}

float easeOutCubic(float x) {
    float y = 1.0 - x;
    return 1.0 - y * y * y;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
#if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
#endif

    // Ghostty deliberately renders unfocused surfaces less frequently. Drawing
    // from their stale cursor uniforms causes detached or hollow-looking trails.
    if (iFocus <= 0 || (iTime - iTimeFocus) < REFOCUS_GUARD_TIME) {
        return;
    }

    if (iResolution.x <= 0.0 || iResolution.y <= 0.0 ||
        any(lessThanEqual(iCurrentCursor.zw, vec2(0.0))) ||
        any(lessThanEqual(iPreviousCursor.zw, vec2(0.0)))) {
        return;
    }

    vec2 point = toNormalized(fragCoord, 1.0);

    vec4 currentCursor = vec4(
        toNormalized(iCurrentCursor.xy, 1.0),
        toNormalized(iCurrentCursor.zw, 0.0)
    );

    vec4 previousCursor = vec4(
        toNormalized(iPreviousCursor.xy, 1.0),
        toNormalized(iPreviousCursor.zw, 0.0)
    );

    // Ghostty cursor.xy is the left/top corner.
    vec2 offsetFactor = vec2(-0.5, 0.5);
    vec2 currentCenter =
        currentCursor.xy - currentCursor.zw * offsetFactor;
    vec2 previousCenter =
        previousCursor.xy - previousCursor.zw * offsetFactor;

    vec2 movement = previousCenter - currentCenter;
    float movementLength = length(movement);

    if (movementLength <= 0.000001) {
        return;
    }

    if (HORIZONTAL_ONLY && abs(movement.y) > 0.00001) {
        return;
    }

    vec2 direction = movement / movementLength;

    // Approximate one cell along the direction of travel.
    float cellLength =
        abs(direction.x) * currentCursor.z +
        abs(direction.y) * currentCursor.w;
    cellLength = max(cellLength, 0.000001);

    if ((movementLength / cellLength) < MIN_MOVE_CELLS) {
        return;
    }

    float horizontalCells = abs(movement.x) / currentCursor.z;
    float verticalCells = abs(movement.y) / currentCursor.w;

    bool singleCellHorizontal =
        verticalCells < CELL_TOLERANCE &&
        abs(horizontalCells - 1.0) <= CELL_TOLERANCE;
    if (SUPPRESS_SINGLE_CELL_HORIZONTAL && singleCellHorizontal) {
        return;
    }

    bool likelyLineWrap =
        abs(verticalCells - 1.0) <= CELL_TOLERANCE &&
        horizontalCells >= WRAP_MIN_HORIZONTAL_CELLS;
    if (likelyLineWrap) {
        return;
    }

    float elapsed = iTime - iTimeCursorChange;
    if (elapsed < 0.0) {
        return;
    }
    float progress = clamp(elapsed / DURATION, 0.0, 1.0);

    if (progress >= 1.0) {
        return;
    }

    // Linear persistence keeps the trail clearly visible for most of its
    // lifetime. The previous cubic curve became almost invisible too quickly.
    float remaining = 1.0 - progress;

    // Keep opacity strong through the first half, then fade smoothly.
    float timeOpacity = pow(remaining, 0.85);

    float cappedLength =
        min(movementLength, MAX_TRAIL_CELLS * cellLength);

    vec2 cappedPreviousCenter =
        currentCenter + direction * cappedLength;

    float trailAlpha = 0.0;

    for (int index = 1; index <= TRAIL_COPIES; ++index) {
        float distanceRank =
            float(index) / float(TRAIL_COPIES);

        // At t=0, copies span current -> previous. As time advances they all
        // collapse toward current, leaving the real cursor unchanged.
        vec2 copyCenter = mix(
            currentCenter,
            cappedPreviousCenter,
            distanceRank * remaining
        );

        float copyMask = rectangleMask(
            point,
            copyCenter,
            currentCursor.zw * 0.5
        );

        // Nearest copies are strongest; distant copies are progressively faint.
        float spatialFade = pow(
            1.0 - distanceRank * 0.82,
            SPATIAL_FADE_POWER
        );

        float copyAlpha =
            MAX_OPACITY * spatialFade * timeOpacity;

        // max(), not addition: overlapping copies never become a bright glow.
        trailAlpha = max(
            trailAlpha,
            copyMask * copyAlpha
        );
    }

    // Cut out the actual cursor rectangle so its apparent size and contrast are
    // controlled entirely by Ghostty, not by this shader.
    float currentCursorMask = rectangleMask(
        point,
        currentCenter,
        currentCursor.zw * 0.5
    );
    trailAlpha *= 1.0 - currentCursorMask;

    vec4 trailColor = vec4(
        srgbToLinear(iCurrentCursorColor.rgb),
        iCurrentCursorColor.a
    );

    fragColor = mix(
        fragColor,
        trailColor,
        trailAlpha * trailColor.a
    );
}
