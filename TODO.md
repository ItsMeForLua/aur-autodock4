I need to review the pipeline for this repo. Just a quick prompt with Claude AI produced this review:

``` markdown
Potential issues with your PKGBUILD:

1. Downloading from `heads/master` is fragile. Your sha256sums will break whenever upstream pushes a commit, since the tarball content changes. You should pin to a specific tag or commit:
 
   source=("...https://github.com/ccsb-scripps/AutoDock4/archive/refs/tags/v4.2.6.tar.gz")
  
   If no tag exists, use a specific commit hash in the URL and set `pkgver` accordingly.

2. The sha256sums will already be wrong for this reason — they'll mismatch as soon as upstream changes anything on master. This will cause `makepkg` to fail in CI with a checksum error.

3. `makedepends` lists `tcsh` — your CI workflow installs it, which is consistent. Good.

4. `autoconf` and `automake` are in `makedepends` but your workflow only installs `base-devel tcsh sudo`. `base-devel` does include `autoconf` and `automake`, so this is fine.

5. `package()` directly installs binaries without a `make install` — this is intentional but means if the upstream build system changes output binary names or paths, it'll break silently. Worth noting.

6. No `check()` function — not required, but if AutoDock has a test suite, CI is exactly where you'd want to run it.

The CI workflow consequence: since you're pulling `heads/master`, every CI run may fetch a different tarball and the hardcoded sha256sums will cause `makepkg` to fail. This is likely your biggest real-world problem right now.
```

Some of these are decent critiques worth reviewing when I have time.
The point regarding pulling directly from master is an issue I've already noted, and will indeed need to point to a tag instead for actual version control.
