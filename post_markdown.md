Hi everyone! Promised keyboard controls change is here.

The PC controls have received a lot of feedback for being perplexing. I am fixing it with this update! With an input-remapping menu still a "maybe if I get to it", I want to apologize for anyone who has already grown accustomed to the shitty last-minute set of keyboard controls. 

How did this bad control scheme get pushed? During development, I played on a mixture of six different controllers (keyboard, Xbox controller, three different 8BitDo controllers, and PS5 controller). The original PC controls were ones which were familiar for me in FPS gaming: Ctrl, shift, Q, E, and Space making for the primary controls.

In the last day of playtesting, I found players getting caught pressing `ctrl+W`, `ctrl+space`, etc. and finding out they were OS shortcuts on Windows. Oops! So, I haphazrdly threw in a new set of PC controls, ~twelve hours before publish.

With a week of time to meditate on it, I put some thought into what a new control scheme should be. I want to enable three rough control schemes:

- "Classic arrow keys", where the left hand is on z-x-c
- "WASD shooter", a one-handed scheme, with jump for space and the keys surrounding WASD coming into use,
- "WASD classic", with the left-hand on WASD and the right-hand on h-j-k-l.

Where players can use any comfortable combination of these to play. :)

With that said, here's the thought process, and how I wittled down a new set of controls:

---

First, WASD and arrow-keys are for directional movement, no questions about it. So, no "classic" bindings can make use of the ASD keys, they'll be limited to the shift-z-x-c-v-b-n row.

For the WASD bindings, I want PC shooter players to feel at home (with Q, E, ctrl, shift, and space playing a big role). So, we'll keep **shift** for ball, **ctrl** for shoot, and **space** for jump.

With these constraints, we can fill out the **classic bindings**. Taking precedent from default-bindings for Pico-8, default bindings from emulators like the VisualBoy Advance, and games like Cave Story or Undertale, we start with **Z** to jump and **X** to shoot. Shift for ball is already on this row, so that works great. The rest of the controls fill out naturally: **C** to aim, **V** to prime, and **B** for the combo move.

> What's the combo move, you ask? It's a secret! I don't want players to have to break their fingers to pull off advanced frame-perfect strats. A special **combo** exists for the sick, dedicated speedrunners, to (1) enter you into the ball and (2) lay a bomb on the same frame.

With the classic bindings filled out, **WASD classic** can be filled out. Here, I [reference VisualBoy Advance again](https://visualboyadvance.org/default-controls), which has the D-pad on WASD and buttons on LKIO. With a whole row above the right hand, I can invert the ZXC keys and put the lesser-used aim/prime/combo keys above. So, we'll have **L** to jump, **K** to shoot, **O** to prime, and **I** to aim, which is perfectly in line with Metroid: Fusion and Metroid: Zero Mission. This leaves **J** as a natural binding for Ball and **U** for a natural binding for combo. To enable a perfect "mirror" of the "classic" binding (with pinky on shift for ball, ring on Z for jump, etc), I'll also provide **;** (semicolon) for Ball.

Returning to the mostly-one-handed **WASD** bindings, we already have ball (shift), shoot (ctrl), and jump (space). To leave the pinky- and middle- fingers free for aiming maneuvers, I will leave **E** to prime, and to make it symmetrical, **Q** to aim diagonally. For ergonomics, I also add **F** to aim diagonally. This leaves **R** to remain for the combo.

Which... Still looks like a mess! But I trust people will 

So, what's left?

- Open sourcing the repo is next,
- Fixing the broken Sfxr sound effects,
- Testing and pushing Mac builds on top of that

