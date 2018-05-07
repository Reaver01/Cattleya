## Cattleya

This bot was originally written for the Monster Hunter Online discord, but you are welcome to invite it to your own server!

https://discordapp.com/oauth2/authorize?&client_id=268825817537052692&permissions=93248&scope=bot

# Current features:

## Commands:

- buy | Buy items from the shop with Zenny.
- eval | (Bot Admin only) Evaluate code.
- info | Show game profile info about yourself or a mentioned user.
- inventory | PM user their current inventory.
- invite | Shows the bot invite link.
- itemshop | PM user the game shop and prices in Zenny.
- kill | (Bot Admin only) Shuts down the bot.
- monsterinfo | Shows info about the monster in the current channel if there is one.
- notify | Toggle PM notifications of level and damage taken.
- spawn | (Bot Admin only) Spawns a monster in the current channel.
- throw | Throw an item at the ground, monster, or another user.
- unstable | (Manage channels server permissions only) Toggle monsters appearing in the current channel.
- use | Use an item on yourself, monster, or another user.


## Levels

- Players gain levels based on their messages sent.
- XP needed to level is on a curve, and XP gain has 30 second timeout.
- Every level the player will gain a random amount of items into their inventory.
- Every level the player will gain a semi-random amount of Zenny based on their new level.


## Hunter Rank

- Players will recieve a HR for participating in killing a monster as long as they did at least 50 + Current HR damage.
- Damage done to monsters scales with HR.


## Monsters

- Monsters have a 10% chance to enter an unstable channel every 10 minutes.
- If a channel has muted the bot they will not be able to have monsters spawn.
- Monsters are killed passively with normal chat.
- Trigger for dealing damage is selected randomly every 3 hours to provide some mystery.
- Monsters may become angry.
- Monster anger is triggered the same way as dealing damage, with a different random trigger.
- Monsters may be trapped making it easier to hit them with bombs.
- Bombs do damage to monsters.
- Successfully hitting a monster with a Dung Bomb will cause it to flee to a different channel that has toggled unstable and does not currently have a monster (This is global)
- Every 3 minutes monsters in the channel will do a random amount of damage to any player that has hurt it based on the amount of damage the player has done.


## Player death (Carting)

- If you take too much damage from a monster and your HP reaches 0 you will have a 5 minute cooldown before your chat messages will do damage to the monster.


## Chat cleanup
- If bot is given manage messages permissions on the server it will try to clean up command triggers that are not nessisary to keep around after command is triggered.
- Most messages have a 1 minute auto delete to keep chat free of too much spam.
- Bots messages can be cleaned up in chat by reacting with the ❌ emoji (`:x:`)

## Emoji response
- Bot will respond to some commands with emoji
- A 💥 emoji (`:boom:`) will be posted on the chat message that triggers the 3 minute damage cooldown from the monster.



# Other info

Shout out to *z64* for all the help he has given me on sequel, and just ruby coding and general! This bot would suck and be a complete mess if it wasn't for that guy!
