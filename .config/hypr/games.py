games = [
    ("all", "Stardew Valley"),
    ("initialclass", "steam_app_.*", "tile", "max"),
    ("all", "ffxiv*", "sf"),
    ("all", "Hollow Knight"),
    ("all", "HELLDIVERS*")
]

def main():
    f = open("config/games.conf", "w")
    conf: str = "# Auto generated window rules for Games\n\n"
    for game in games:
        if type(game) is not tuple:
            continue

        name = game[1]
        match game[0]:
            case "initialclass":
                selector = f"initialclass:({name})"
            case "title":
                selector = f"title:({name})"
            case "class":
                selector = f"class:({name})"
            case "all":
                selector = f"title:({name}), class:({name})"
            case s:
                print(f"Could not find selector for \"{s}\"")
                continue

        for setting in game[2::]:
            match setting:
                case "sf":
                    conf += f"windowrulev2 = stayfocused, {selector}\n"
                case "tile":
                    conf += f"windowrulev2 = tile, {selector}\n"
                case "max":
                    conf += f"windowrulev2 = maximize, {selector}\n"
                case s:
                    print(f"Could not find setting \"{s}\"")
 

        conf += f"""windowrulev2 = fullscreen, {selector}
windowrulev2 = monitor DP-3, {selector} 
windowrulev2 = forceinput, {selector}\n
"""
    f.write(conf)
    f.close()


if __name__ == "__main__":
    main()
  
