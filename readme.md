Platform Game
=============

Hey, I'm playing around with Godot for funsies. This is the repo where I put what I create.

Any code or assets that I create here are public domain.

Dev Diary
---------

### 001 - Tileset and sprite animations

Following HeartBeast's tutorials (https://www.youtube.com/watch?v=BfQGXtlmE7k), except with a different tileset (https://opengameart.org/content/platformer-art-deluxe).

Challenges: The tileset I'm using is 70x70 tiles with a 2 pixel gutter between, so the grid snapping didn't really work. I compensated with grid offset, but it was pretty awkward making the tilemap. There's an XML file for the tilemap, so there's probably a way to just import that, but I wanted to try it manually.

### 002 - Better physics

One annoyance with how I built the jumping physics is the player has no control mid-flight. Also, no acceleration or friction, so: tweaked the logic. I also added a basic camera.

Challenges: originally I just accelerated in whatever direction the arrow as pointing, but it made it very difficult to drop straight down mid-jump. You'd jump right, tap left, and be flying to the left, instead of down. So I set the logic that if you're moving in the opposite direction above a certain threshold, I apply friction rather than accelerating in the opposite direction. This seems to make it easier to stop a jump and just feels better. The consts need some adjustments, but this an OK starting point.

I also added a crouch capability. When you crouch, friction is reduced to a ridiculously small amount of friction and it's kind of hilarious watching your dude slide for miles. The problem is that if you pop-up, your collision changes and you can get stuck inside blocks. I'll fix that... someday, maybe.

Ducking challenge: Originally I had the down press detection in the same block as left, right, and jump. This meant you had to let go of any other button to duck and that felt awkward. So I put ducking first and gave it priority. Now you can duck, still hold left/right, and slide and then rise into a run. You can't duck and jump at the same time though. That's a thing I loved in Mario Brothers so I may see if I can get that working later.

### 003 - Level jumping

Added an "exit," basically following this: https://www.youtube.com/watch?v=KzLfi0r4Muw. My son designed World 1. World 2 just exists for now. For an extra bit of *je ne sais quoi*, we added a welcome message that "fades" in, and then out after a delay in World 1.

Challenges: I didn't have the function signature correct for the "tween_completed" signal, so it was kind of silently failing (or maybe there was a message in the debug log and I was too dense to notice it). A quick google search cleared that up, though.

Now that I'm writing this up, it occurs to me I should have linked back to level 1 to see how/if state is maintained. If I exit level 2 back to 1, do I see the welcome message again? Or is that opening tween considered done? I shall find out next time.

### 004 - Parallax background

Added a background. This didn't go quite as smoothly as in the tutorial, but I probably missed a step. I'm also using a (relatively) smaller tile. I had to move it around a bit and make a few duplicates to ensure it covered the full screen. But otherwise it was remarkably easy.

