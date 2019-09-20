# I/O ====
context("io")

test_that("workflows are read in", {
  getwd()
  workflows <- read_workflows(path = "workflows")
  expect_equal(
    object = workflows$`workflows/named.yml`$name,
    expected = "foo"
  )
  expect_equal(
    object = workflows$`workflows/unnamed.yaml`$name,
    expected = "workflows/unnamed.yaml"
  )
})


# Workflows ====
context("workflows")

test_that("can be written out", {
  # these examples are based on https://help.github.com/en/articles/workflow-syntax-for-github-actions, but do look slightly different
  # 'on' needs to be escaped in all of the below test cases for some reason; doesn't hurt ghactions
  expect_known_output(
    object = write_workflow(workflow(name = "foo")),
    file = "workflows/named.yml"
  )
  expect_known_output(
    object = write_workflow(workflow()),
    file = "workflows/unnamed.yaml"
  )
  expect_known_output(
    # sequences must be separate lines; doesn't hurt ghactions
    object = write_workflow(workflow(on = c("push", "pull_request"))),
    file = "workflows/on_multiple.yml"
  )
  expect_known_output(
    object = write_workflow(
      workflow(
        on = on(
          event = "push",
          branches = c("master", "releases/*"),
          tags = c("v1", "v1.0")
        )
      )
    ),
    file = "workflows/on_push_filter.yml"
  )
  expect_known_output(
    object = write_workflow(
      workflow(
        on = on(
          event = "push",
          paths = c("*", "!*.js")
        )
      )
    ),
    file = "workflows/on_push_path.yml"
  )
  expect_known_output(
    object = write_workflow(
      workflow(
        on = on(
          event = "schedule",
          cron = "*/15 * * * *"
        )
      )
    ),
    file = "workflows/on_schedule.yml"
  )
})


# jobs ====
context("jobs")

test_that("can be written out", {
  # these examples are based on https://help.github.com/en/articles/workflow-syntax-for-github-actions, but do look slightly different
  expect_known_output(
    object = write_workflow(
      job(
        id = "some_job",
        name = "bar",
        needs = c("zap", "zong")
      )
    ),
    file = "workflows/job.yml"
  )
})


context("actions")

test_that("can override entrypoint", {
  expect_equal(
    object = {
      action2docker(
        l = action(
          IDENTIFIER = "Test",
          uses = "alpine:3.10.1",
          runs = "echo",
          args = "foo"
        ),
      )$stdout
    },
    expected = "foo\n"
  )
})

test_that("fail on error", {
  expect_error(
    action2docker(
      l = action(
        IDENTIFIER = "Test",
        uses = "alpine:3.10.1",
        runs = "sh",
        args = c("-c", "exit 1")
      )
    )
  )
})

test_that("pass on environment arguments", {
  expect_equal(
    object = {
      action2docker(
        l = action(
          IDENTIFIER = "Test",
          uses = "alpine:3.10.1",
          runs = "sh",
          args = c("-c", "echo $BAR"),
          env = list(BAR = "foo", ZAP = "zong")
        ),
      )$stdout
    },
    expected = "foo\n"
  )
})
