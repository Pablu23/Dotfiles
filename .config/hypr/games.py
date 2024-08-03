games = [
    "Stardew Valley",
    "steam_app_.*",
    ("ffxiv*", "sf"),
    "Hollow Knight",
]

def main():
    f = open("config/games.conf", "w")
    conf: str = "# Auto generated window rules for Games\n\n"
    for game in games:
        if type(game) is tuple:
            name = game[0]
            for setting in game[1::]:
                match setting:
                    case "sf":
                        conf += f"windowrulev2 = stayfocused, class:({name}), title:({name})\n"
        else:
            name = game

        conf += f"""windowrulev2 = fullscreen, class:({name}), title:({name})
windowrulev2 = monitor DP-3, class:({name}), title:({name})
windowrulev2 = forceinput, class:({name}), title:({name})

"""
    f.write(conf)
    f.close()


if __name__ == "__main__":
    main()
  
