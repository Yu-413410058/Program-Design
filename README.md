# Dino's Bizarre Adventure

## Background Story

You play as the dinosaur from Chrome's Dino Game — but this time, it’s not just an endless runner!  
Your mission is to overcome unique obstacles and face off against your greatest nightmare:  
**YOU... but bigger, stronger, and meaner!**

---

## Game Features

### Player Controls

- **Move**: `A` / `←` for Left, `D` / `→` for Right  
- **Jump**: `W` / `Space`  
- **Dash**: `Shift` (Temporary invincibility)  

### Abilities

- **Fireball**: Press `1` or `J` – Deals 1 damage on hit  
- **Flame**: Hold `2` or `K` – Deals 2 damage every 0.5s  
- **Heal**: Press `3` or `L` – Restores 2 HP  
  > ⚠️ While healing, your movement speed and jump height are halved!

💡 Collect coins and defeat enemies to **increase your max HP** (starting at 5)!

---

## Special Platforms

- ** Invisible Platforms**: Toggle visibility every 2 seconds  
- ** Windy Platforms**: Push the player rightward continuously  
- ** Lava Platforms**: Deal 1 damage per second  

---

##  Checkpoints

- Two checkpoints are placed before the final boss to save your progress!
- One in middle of invisible platforms, the other one in the windy platforms
- ⚠️ Press Ctrl+Z to respawn at the last checkpoint

---


##  Boss Fight – The Bigger Dino

Once you reach the end, prepare to battle your ultimate nemesis: **Shadow Dino** — a more powerful version of yourself.

###  Phase 1 (Boss HP ≥ 50%)

- **Meteor Attack**:  
  Boss stops and eyes glow red, then summons a meteor dealing **2 damage**.

- **Jump Smash**:  
  Boss jumps to your position, dealing **2 damage**.

---

###  Phase 2 (Boss HP < 50%)

Boss becomes much more dangerous:

- **Meteor Rain**:  
  Meteors fall **automatically** while the boss continues to move — **2 damage per hit**.

- **Faster Jump Attack**:  
  Increased speed and precision when jumping to your location.

- **Self-Healing**:  
  Occasionally restores **5 HP**.

> ⚠️ Phase 2 is **permanent**, even if HP returns above 50%.

---

###  Arena Hazards (Phase 2 Only)

- The arena floor is covered with **flames**.
- Standing in fire causes **1 damage every 2 seconds**.

---

###  Battle Zone Rules

- The **fight starts at the bottom of the staircase**.
- Leaving the zone causes the boss to **stop chasing**.
- Re-entering resumes from the current phase and HP.

---

## 🧾 Player Record System

After defeating the boss, your performance will be displayed on screen, including:

- **Completion Time**
- **Total Deaths**
- **Player Damage Taken**
- **Boss Damage Dealt**

These records are automatically saved to a text file PlayerRecords.txt, you may have to search it up inside your userdata folder

Each entry is sorted based on:
1. **Shortest time**
2. **Lowest deaths** (if times are equal)

You will then be prompted with two choices:

- Press **`R`** to **restart the game** and continue with your current max health.
- Press **`E`** to **exit the game**.


