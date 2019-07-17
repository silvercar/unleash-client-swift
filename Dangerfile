declared_trivial = github.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

fail "We cannot handle the scale of this PR" if git.lines_of_code > 50_000

fail "Don't delete this file" if git.deleted_files.include? "Dangerfile"
fail "Don't delete this file" if git.deleted_files.include? ".circleci/config.yml"

fail "Please provide a summary in the Pull Request description" if github.pr_body.length < 5

# Rebase instead of merge commits
fail 'Please rebase to get rid of the merge commits in this PR' if git.commits.any? { |c| c.message =~ /^Merge branch/ }
