#' Check whether system dependency is available
#' @noRd
# TODO use something like this from another package (this is duplicated from pensieve)
check_sysdep <- function(x) {
  sys_test <- checkmate::test_character(
    x = Sys.which(x),
    min.chars = 2,
    any.missing = FALSE,
    all.missing = FALSE,
    len = 1,
    null.ok = FALSE
  )
  if (sys_test) {
    return(TRUE)
  } else {
    return(
      glue::glue(
        "Could not find",
        x,
        "system dependency. Try installing it",
        .sep = " "
      )
    )
  }
}
assert_sysdep <- checkmate::makeAssertionFunction(check.fun = check_sysdep)
test_sysdep <- checkmate::makeTestFunction(check.fun = check_sysdep)


#' Test whether runtime is docker
#'
#' @noRd
is_docker <- function() {
  cgroup <- fs::path("/", "proc", "1", "cgroup")
  if (fs::file_exists(cgroup)) {
    # cgroup is not a real flat file, but an interface to the kernel
    # cannot easily be read into R, because it does not have a size
    # so we do this with grep
    docker_processes <- processx::run(
      command = "grep",
      args = c("docker\\|lxc", cgroup),
      error_on_status = FALSE
    )$status
    if (docker_processes == 0) {
      return(TRUE)
    }
  }
  FALSE
}


#' Test whether docker daemon is available
#'
#' @noRd
is_dockerd <- function() {
  # TODO find a better cross-platform way to test for docker daemon
  assert_sysdep("docker")
  processx::run(
    command = "docker",
    args = "ps",
    error_on_status = FALSE
  )$status == 0
}
