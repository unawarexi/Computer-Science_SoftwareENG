package packagesandmodules

import "fmt"

// =============================================================================
// This file demonstrates Go module concepts: the `require` and `replace`
// directives in go.mod, and how they affect dependency resolution.
//
// NOTE: The actual go.mod changes must be made in the go.mod file. This file
// demonstrates the concepts in code comments and simulated examples.
// =============================================================================

// =============================================================================
// SECTION 1: The `require` Directive
//
// `require` in go.mod lists every external module your project depends on,
// along with its exact semantic version. Go guarantees reproducible builds
// by always using the exact version listed.
//
// Example go.mod with require:
//
//   module github.com/myorg/myapp
//
//   go 1.21
//
//   require (
//       github.com/google/uuid   v1.3.0       // direct dependency
//       golang.org/x/sys         v0.12.0      // indirect (added by uuid)
//   )
//
// To add a requirement, run:
//   go get github.com/google/uuid@v1.3.0
//
// To remove unused requirements and add missing ones, run:
//   go mod tidy
// =============================================================================

// DemonstrateRequire explains the require directive and version semantics.
func DemonstrateRequire() {
	fmt.Println("=== The `require` Directive ===")
	fmt.Println()

	fmt.Println("Semantic Versioning (SemVer): vMAJOR.MINOR.PATCH")
	fmt.Println("  v1.3.0 → Major=1, Minor=3, Patch=0")
	fmt.Println()

	versions := []struct {
		Version     string
		Explanation string
	}{
		{"v1.3.0", "Exact version — fully pinned, reproducible builds"},
		{"v1.3.0 // indirect", "Indirect — required by a direct dep, not your code"},
		{"v0.0.0-20231001120349-abcdef", "Pseudo-version — specific commit, no tag"},
	}

	fmt.Println("Version formats you'll see in go.mod:")
	for _, v := range versions {
		fmt.Printf("  %-45s → %s\n", v.Version, v.Explanation)
	}

	fmt.Println()
	fmt.Println("Key commands:")
	fmt.Println("  go get github.com/pkg@v1.0.0    — add/update a specific version")
	fmt.Println("  go get github.com/pkg@latest    — upgrade to the latest version")
	fmt.Println("  go mod tidy                     — sync go.mod with actual imports")
	fmt.Println("  go list -m all                  — list all resolved module versions")
}

// =============================================================================
// SECTION 2: The `replace` Directive
//
// `replace` overrides where Go resolves a module. There are three main uses:
//
// USE CASE 1 — Local development (most common):
//   replace github.com/myorg/mylib => ../mylib
//   (Points to a directory on your local filesystem)
//
// USE CASE 2 — Using a forked/patched version:
//   replace github.com/original/lib => github.com/myfork/lib v1.0.1-fix
//
// USE CASE 3 — Version pinning (replace one version with another):
//   replace github.com/some/module v1.0.0 => github.com/some/module v1.0.1
//
// IMPORTANT: `replace` only works in the root (main) module.
// It is IGNORED when your module is imported as a library by others.
// =============================================================================

// DemonstrateReplace explains the replace directive and its three use cases.
func DemonstrateReplace() {
	fmt.Println("=== The `replace` Directive ===")
	fmt.Println()

	useCases := []struct {
		Title   string
		GoMod   string
		Explain string
	}{
		{
			Title: "1. Local Development / Working on a Dependency Side-by-Side",
			GoMod: `require github.com/myorg/mylib v1.0.0

replace github.com/myorg/mylib => ../mylib`,
			Explain: "Go reads the module from the local '../mylib' directory instead of the registry.",
		},
		{
			Title: "2. Using a Forked Module with a Bug Fix",
			GoMod: `require github.com/original/library v1.2.3

replace github.com/original/library => github.com/my-fork/library v1.2.3-patched`,
			Explain: "Swap the original for your fork without changing any import paths in your code.",
		},
		{
			Title: "3. Pinning a Version (Upgrading a Transitive Dep)",
			GoMod: `require github.com/some/module v1.0.0

replace github.com/some/module v1.0.0 => github.com/some/module v1.0.1`,
			Explain: "Force a specific version of a transitive dependency — useful for security patches.",
		},
	}

	for _, uc := range useCases {
		fmt.Println("---")
		fmt.Println(uc.Title)
		fmt.Println("go.mod snippet:")
		fmt.Println(uc.GoMod)
		fmt.Println("Effect:", uc.Explain)
		fmt.Println()
	}

	fmt.Println("⚠️  Warning: replace is ignored by downstream users of your module.")
	fmt.Println("   Use it in applications (main modules), not in libraries.")
}

// =============================================================================
// SECTION 3: Combining require and replace — a Realistic Workflow
//
// This simulates what happens during local multi-module development,
// where you have an app and a library in separate directories.
// =============================================================================

// moduleWorkflow simulates the decisions the Go toolchain makes when
// resolving modules at build time.
func moduleWorkflow() {
	fmt.Println("=== Multi-Module Development Workflow ===")
	fmt.Println()

	steps := []string{
		"1. Initialize app:      go mod init github.com/myorg/myapp",
		"2. Initialize lib:      go mod init github.com/myorg/mylib  (in ../mylib/)",
		"3. Add dependency:      go get github.com/myorg/mylib@v1.0.0",
		"4. Start editing lib:   Add `replace github.com/myorg/mylib => ../mylib` to go.mod",
		"5. Build locally:       go build ./...  — uses local ../mylib instead of registry",
		"6. Publish lib:         git tag v1.1.0 && git push --tags",
		"7. Remove replace:      Delete the replace directive",
		"8. Update require:      go get github.com/myorg/mylib@v1.1.0",
		"9. Commit:              Commit updated go.mod and go.sum",
	}

	for _, step := range steps {
		fmt.Println(" ", step)
	}
}

// DemonstrateModules runs all module-related examples.
func DemonstrateModules() {
	DemonstrateRequire()
	fmt.Println()
	DemonstrateReplace()
	fmt.Println()
	moduleWorkflow()
}
