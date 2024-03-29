#!/usr/bin/env Rscript

source_root <- NULL
# bad hack to make local debugging easier #269
if (getwd() == "/Users/max/GitHub/ghactions/actions/document") {
  source_root <- "../../"
} else if (getwd() != "/Users/max/GitHub/ghactions") {
  source_root <- "/ghactions-source/"
}

arguments <- docopt::docopt(
  doc = readr::read_file(paste0(source_root, "actions/document/man")),
  help = TRUE,
  strip_names = TRUE
)

message("Checking for consistency of roxygen2 with `man` and `NAMESPACE` ...")

res <- ghactions::auto_commit(
  after_code = arguments$`--after-code`,
  code = {
    # to prevent compiled code from other platforms for act #285
    pkgbuild::clean_dll()
    # fix for #277 waiting for upstream resolution (?) of https://github.com/klutometis/roxygen/issues/822
    pkgbuild::compile_dll()
    devtools::document()
  },
  path = ".",
  before_code = arguments$`--before-code`
)
print(res)
