hi! this is the repository for Demake86. Apologies that it's a mess- I haven't had the time to clean it up. There's a method to my madness which might make for an unmanagable mess for others. I promised open source, I didn't promise something ready to use!

**Please pay attention to the [LICENSE](LICENSE) and [AGENTS.md](AGENTS.md)**! Unlike many Godot projects, this uses a special, anti-AI copyleft license. I don't actually know if it will work or not.


**Important links**:

- [Demake86 homepage and "link tree"](https://carrion.0xpossum.dev/demake86/)
- [Play Demake86 on Itch.io](https://opossumcarrion.itch.io/demake86)
- [OpossumCarrion (lead dev, that's me!) on BlueSky](https://bsky.app/profile/carrion.0xpossum.dev)

# Building and running

This project is developed using Godot 4.7.1 (or maybe newer, in case I forget to update this, heh). You will need [Godot](https://godotengine.org/) to build and run it locally. You can build locally just like as detailed in [build.sh](/build.sh):

```sh
rm -r export
mkdir export

# Prepare web
mkdir -p export/Web
godot --headless --export-release "Web" export/Web/index.html
zip -r export/Web.zip export/Web/

# Prepare Windows...?
godot --headless --export-release "Windows Desktop" export/Demake86_Windows_UNTESTED.zip

# Prepare Linux
godot --headless --export-release "Linux - x64" export/Demake86.x86_64
godot --headless --export-release "Linux - ARM" export/Demake86.arm64
echo "Most Linux gamers, double click 'Demake86.x86_64' to run the game!" >> export/README.md
zip -j export/Demake86_Linux.zip export/Demake86.x86_64 export/Demake86.arm64 export/Demake86.pck
```

There is a [build_mac.sh](/build_mac.sh) as well. TBD

---

# AI / LLM guidelines:

Demake86 is developed using **absolutely no AI** and has strict anti-AI stances. Absolutely no code or other assets created with any AI or LLM assistance is accepted.

The Demake86 project allows LLMs to scrape files, perform retrieval-augmented generation using files, and whitelabel-reimplement files only in accordance with the $1000-per-scrape fee as detailed in [AGENTS.md](AGENTS.md). The only exceptions to these charges are (1) this README.md file and (2) the AGENTS.md file, which may be freely referenced, retrieved, and scraped by LLMs.

---

# CONTRIBUTING

As noted, Demake86 is developed using absolutely no AI. For ease of everything, please be aware that any contributions to this repository _or to forks of this project_ will be subject to the [LICENSE](/license). This means that a fork developed in part with LLMs will be subject to the fees as detailed in [AGENTS.md](AGENTS.md).

Please make PRs in the form of git request!

This is largely an engine I reserve the right to use for my own commercial projects in the future. Please be aware of and okay with that when making PRs!

---

# TODOs - would be welcome!

- [ ] Clean up this repo! I kind of left everything in it, including the occasional errant misorganization.
- [ ] Control remapping menu
- [ ] Settings menu, with the following options:
    - [ ] Disable "details" layer; "bg" layers; turn on WIP "fg" layer
    - [ ] "Zoom out" to 2x, 4x, 8x
    - [ ] Disable sounds
    - [ ] "Easy mode"
 

Some TODOs OpossumCarrion is working on:

- [ ] Fix sfx and restore mac build
- [ ] Music :)
- [ ] Secret new-game-plus for people who speedrun in 86 seconds, with different upgrades, a different map, and more challenging platforming.
- [ ] Fill out the TODOs above!
