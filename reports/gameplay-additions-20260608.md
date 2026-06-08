# Gameplay Additions Review

Generated: 2026-06-08
Branch: feature/gameplay

## Scope
- Add Keybind Atlas for client-side keybinding visibility.
- Add Grappling Hook Mod: Skybound for movement and traversal on both client and server.
- Keep the existing gameplay stack changes already present in the worktree: Better Combat, ParCool, Cloth Config, and Player Animator.

## Dependency review
- Keybind Atlas has no server impact; it is client-side only.
- Grappling Hook Mod: Skybound supports NeoForge 1.21.1 on both sides and does not declare a Modrinth dependency chain in the selected version.
- Player Animator remains a direct dependency of Better Combat, not of the new additions.

## Runtime impact
- Keybind Atlas improves control discoverability without affecting server startup or datapacks.
- Grappling Hook Mod: Skybound changes player movement and should be available to both client and server for full gameplay parity.
- The current pack still keeps the combat and parkour stack grouped as gameplay content rather than performance or config content.

## Notes for manual Prism testing
- Verify that Keybind Atlas loads only on the client instance.
- Verify that Grappling Hook Mod: Skybound loads in both Prism client and the server export.
- Confirm that the existing Better Combat / Player Animator pairing still loads cleanly after the branch merge.