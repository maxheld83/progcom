#' @title Fix documentation
#'
#' @description
#' This GitHub action creates `man/` documentation from [*roxygen*](https://github.com/klutometis/roxygen/) comments in `R/` scripts at the repository root using [*devtools*](https://devtools.r-lib.org).
#'
#' @inherit workflow
#'
#' @inheritParams auto_commit
#'
#' @details
#' If you set `after_code = 'commit'` this action will automatically commit and push changes to your repository for you.
#' This will pollute your commit history and may cause unintended interruptions, such as merge conflicts *with yourself*.
#' The programmatic commit will not trigger another action run, but may trigger other workflow automations (such as Travis and AppVeyor).
#'
#' GitHub actions are currently available only in repos who belong to organisations or personal accounts who are on the beta.
#' GitHub actions always runs against the repo to which the push was made, and does not currently support pull requests.
#'
#' For more caveats, see [auto_commit()].
#'
#' @export
fix_docs <- function(IDENTIFIER = "Fix Documentation",
                     after_code = NULL) {
  # Input validation

  # TODO this is a stupid roundtrip of R argument to bash to R to wherever
  if (isTRUE(after_code == "commit")) {
    after_code <- "--after-code=commit"
  }

  rlang::exec(.fn = list, !!!list(
    IDENTIFIER = IDENTIFIER,
    on = "push",
    resolves = c("Document Package"),
    actions = list(
      install_deps(),
      document(needs = "Install Dependencies", args = after_code)
    )
  ))
}
