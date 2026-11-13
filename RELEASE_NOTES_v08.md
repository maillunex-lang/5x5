# ETERNAL LEGENDS ONLINE v0.8: APK pipeline and arena fix

- Fixed arena shadow draw transform reset that could render unit body at the wrong position.
- GitHub Actions workflow now attempts a real Godot 4.3 headless import, smoke test and Android debug APK export, then uploads the APK and checksum as a short-lived workflow artifact.
- Added four static regression tests for render transform and build workflow.
- Workflow has NOT been run; APK has NOT been produced or verified.
- No changes to VPS, GitHub repositories or other games.

## How to run
On a fresh isolated machine with Godot 4.3, Android export templates, Java and Android SDK, run `bash tools/build_android.sh`. Or commit this project to an authorized GitHub repository and run `Godot Android validation and APK` workflow. The container image must have a valid Android SDK and debug signing setup; check workflow logs if export fails.