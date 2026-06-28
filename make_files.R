weeks <- 1:16

# Create folders if not exist
dir.create("questions", showWarnings = FALSE)
dir.create("answers", showWarnings = FALSE)

# Generate weekly QMD files
for (w in weeks) {
  # Question files
  qfile <- sprintf("questions/wk%d.qmd", w)
  if (!file.exists(qfile)) {
    writeLines(c(
      "---",
      sprintf("title: 'Week %d Questions'", w),
      "format: html",
      "---",
      "",
      "# Questions",
      ""
    ), qfile)
  }
  
  # Answer files
  afile <- sprintf("answers/wk%d_answer.qmd", w)
  if (!file.exists(afile)) {
    writeLines(c(
      "---",
      sprintf("title: 'Week %d Answers'", w),
      "format: html",
      "---",
      "",
      "# Answers",
      ""
    ), afile)
  }
}
