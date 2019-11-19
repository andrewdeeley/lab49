#' @export reorder_cor_mat
#' @import data.table


##########################
### adapted from lessR ###
##########################
reorder_cor_mat = function(corM,n_clusters,method,dist_method,plot_heat_map=T,pdf_file = NULL, width = 5,height = 5,bottom = 3, right = 3,main=NULL){
  if(missing(dist_method)) dst  = as.dist(1 - corM)
  ord = hclust(dst, method = method)
  Label = ord$order
  sector = sort(cutree(ord, k = n_clusters))
  dttp = data.table(names(sector),sector)
  setnames(dttp,'V1','Ticker')
  setkey(dttp,Ticker)
  corM = corM[Label, Label]
  if(plot_heat_map){
    .corcolors(corM, nrow(corM), main, bottom, right, diag = NULL,
               pdf_file, width, height)
  }
  out= list()
  out$cor = corM
  out$sectors = copy(dttp)
  out
}


.corcolors = function (R, NItems, main, bm = 3, rm = 3, diag = NULL, pdf_file,
                       width, height)
{
  if (!is.null(diag)) {
    for (i in 1:NItems) R[i, i] <- diag
    cat("\\nNote: To provide more color separation for off-diagonal\\n",
        "      elements, the diagonal elements of the matrix for\\n",
        "      computing the heat map are set to 0.\\n", sep = "")
  }
  .opendev(pdf_file, width, height)
  fill_low <- NULL
  fill_hi <- NULL
  if (is.null(fill_low) && is.null(fill_hi)) {
    if ( "colors" %in% c("colors", "dodgerblue",
                         "blue", "lightbronze")) {
      fill_low <- "rusts"
      fill_hi <- "blues"
      hmcols <- getColors(fill_low, fill_hi, l = c(10,
                                                   90), n = 100)
    }
    else if (getOption("theme") %in% c("darkred", "red",
                                       "rose")) {
      fill_low <- "turquoises"
      fill_hi <- "reds"
      hmcols <- getColors(fill_low, fill_hi, l = c(10,
                                                   90), n = 100)
    }
    else if (getOption("theme") %in% c("darkgreen", "green")) {
      fill_low <- "violets"
      fill_hi <- "greens"
      hmcols <- getColors(fill_low, fill_hi, l = c(10,
                                                   90), n = 100)
    }
    else if (getOption("theme") %in% c("gold", "brown", "sienna")) {
      fill_low <- "blues"
      fill_hi <- "browns"
      hmcols <- getColors(fill_low, fill_hi, l = c(10,
                                                   90), n = 100)
    }
    else if (getOption("theme") %in% c("gray", "white")) {
      fill_low <- "white"
      fill_hi <- "black"
      hmcols <- colorRampPalette(c("white", "gray75", "black"))(100)
    }
  }
  else if (is.null(fill_low) || is.null(fill_hi)) {
    fill_low <- "white"
    fill_hi <- "gray20"
    hmcols <- colorRampPalette(c("white", "gray75", "black"))(100)
  }
  axis_x_cex <- ifelse(is.null(getOption("axis_x_cex")), 0.75,
                       getOption("axis_x_cex"))
  axis_y_cex <- ifelse(is.null(getOption("axis_y_cex")), 0.75,
                       getOption("axis_y_cex"))
  heatmap(R[1:NItems, 1:NItems], Rowv = NA, Colv = "Rowv",
          symm = TRUE, col = hmcols, margins = c(bm, rm), main = main,
          cexRow = axis_x_cex, cexCol = axis_y_cex)
  if (!is.null(pdf_file)) {
    dev.off()
    .showfile(pdf_file, "plot")
  }
}

.opendev = function (pdf.fnm, width, height) {
  if (is.null(pdf.fnm)) {
    if (options("device") != "RStudioGD" && is.null(options()$knitr.in.progress)) {
      .graphwin(1, d.w = width, d.h = height)
      orig.params <- par(no.readonly = TRUE)
      on.exit(par(orig.params))
    }
  }
  else pdf(file = pdf.fnm, width = width, height = height,
           onefile = FALSE)
}


getColors = function (pal = NULL, end_pal = NULL, n = 12, h = 0, h2 = NULL,
                      c = NULL, l = NULL, trans = 0, in_order = NULL, fixup = TRUE,
                      power = NULL, shape = c("rectangle", "wheel"), radius = 0.9,
                      border = "lightgray", main = NULL, labels = NULL, labels_cex = 0.8,
                      lty = "solid", output = NULL, quiet = getOption("quiet"),
                      ...)
{
  dots <- list(...)
  if (!is.null(dots))
    if (length(dots) > 0) {
      change <- c("end.pal", "in.order", "labels.cex")
      for (i in 1:length(dots)) {
        if (names(dots)[i] %in% change) {
          nm <- gsub(".", "_", names(dots)[i], fixed = TRUE)
          assign(nm, dots[[i]])
          get(nm)
        }
      }
    }
  shape <- match.arg(shape)
  miss_h <- ifelse(missing(h), TRUE, FALSE)
  miss_l <- ifelse(missing(l), TRUE, FALSE)
  miss_c <- ifelse(missing(c), TRUE, FALSE)
  if (!is.null(end_pal) && length(pal) > 1) {
    cat("\\n")
    stop(call. = FALSE, "\\n", "------\\n", "To specify a sequence of colors, only specify one beginning color\\n\\n")
  }
  if (is.null(in_order))
    in_order <- ifelse(shape == "wheel", TRUE, FALSE)
  if (!missing(h2) && in_order == FALSE) {
    cat("\\n")
    stop(call. = FALSE, "\\n", "------\\n", "h2 only applies to generate a straight sequence of HCL colors\\n",
         "  so in_order must be TRUE\\n\\n")
  }
  if (border == "off")
    border <- NA
  ln.c <- length(c)
  ln.l <- length(l)
  if (is.null(pal) && is.null(end_pal) && ln.c == 1 && ln.l ==
      1) {
    if (getOption("theme") %in% c("gray", "white"))
      pal <- "grays"
    else pal <- "hues"
  }
  if (!is.null(pal[1]))
    if (pal[1] == "yellows")
      pal[1] <- "browns"
  if (!is.null(end_pal))
    if (end_pal == "yellows")
      end_pal <- "browns"
  nm <- c("reds", "rusts", "browns", "olives", "greens", "emeralds",
          "turquoises", "aquas", "blues", "purples", "violets",
          "magentas", "grays")
  nmR <- c("rainbow", "heat", "terrain")
  nmV <- c("viridis", "cividis", "magma", "inferno", "plasma")
  nmD <- c("distinct")
  nmW <- c("BottleRocket1", "BottleRocket2", "Rushmore1", "Rushmore",
           "Royal1", "Royal2", "Zissou1", "Darjeeling1", "Darjeeling2",
           "Chevalier1", "FantasticFox1", "Moonrise1", "Moonrise2",
           "Moonrise3", "Cavalcanti1", "GrandBudapest1", "GrandBudapest2",
           "IsleofDogs1", "IsleofDogs2")
  if (!is.null(pal)) {
    if (pal[1] %in% nm) {
      kind <- "sequential"
      if (!is.null(end_pal[1]))
        if (end_pal[1] %in% nm)
          kind <- "divergent"
    }
    else if (pal[1] %in% nmR)
      kind <- "seq.R"
    else if (pal[1] == "hues")
      kind <- "qualitative"
    else if (pal[1] %in% nmV)
      kind <- "viridis"
    else if (pal[1] %in% nmW)
      kind <- "wes"
    else if (pal[1] %in% nmD)
      kind <- "distinct"
    else {
      if (is.null(end_pal))
        kind <- "manual.q"
      else kind <- "manual.s"
    }
  }
  else {
    if (length(c) > 1 || length(l) > 1)
      kind <- "sequential"
    else kind <- "qualitative"
  }
  if (is.null(labels))
    labels <- ifelse(kind == "qualitative", TRUE, FALSE)
  if (!is.null(pal)) {
    if (pal[1] %in% nm && !(pal[1] %in% nmR)) {
      if (pal[1] == "reds")
        h <- 0
      if (pal[1] == "rusts")
        h <- 30
      if (pal[1] == "browns")
        h <- 60
      if (pal[1] == "olives")
        h <- 90
      if (pal[1] == "greens")
        h <- 120
      if (pal[1] == "emeralds")
        h <- 150
      if (pal[1] == "turquoises")
        h <- 180
      if (pal[1] == "aquas")
        h <- 210
      if (pal[1] == "blues")
        h <- 240
      if (pal[1] == "purples")
        h <- 270
      if (pal[1] == "violets")
        h <- 300
      if (pal[1] == "magentas")
        h <- 330
      if (pal[1] == "grays") {
        c <- 0
        miss_c <- FALSE
      }
      if (is.null(end_pal))
        pal <- NULL
    }
    if (!is.null(end_pal)) {
      if (end_pal %in% nm && !(end_pal %in% nmR)) {
        if (end_pal == "reds")
          h2 <- 0
        if (end_pal == "rusts")
          h2 <- 3
        if (end_pal == "browns")
          h2 <- 60
        if (end_pal == "olives")
          h2 <- 90
        if (end_pal == "greens")
          h2 <- 120
        if (end_pal == "emeralds")
          h2 <- 150
        if (end_pal == "turquoises")
          h2 <- 180
        if (end_pal == "aquas")
          h2 <- 210
        if (end_pal == "blues")
          h2 <- 240
        if (end_pal == "purples")
          h2 <- 270
        if (end_pal == "violets")
          h2 <- 300
        if (end_pal == "magentas")
          h2 <- 330
        if (end_pal == "grays") {
          c <- 0
          miss_c <- FALSE
        }
        pal <- NULL
      }
    }
  }
  lbl <- character(length = n)
  if (kind == "qualitative") {
    if (!miss_h)
      if (length(h) > 1)
        n <- length(h)
      if (is.null(h2))
        h2 <- h + (360 * (n - 1)/n)
      if (n <= 24) {
        if (!in_order) {
          h <- c(240, 60, 120, 0, 275, 180, 30, 90, 210,
                 330, 150, 300)
          h <- c(h, h + 15)
        }
        else h <- seq(h, h2, length = n)
      }
      else {
        h <- seq(h, h2, length = n)
        if (!in_order) {
          o <- sample.int(n)
          h <- h[o]
        }
      }
      h[which(h >= 360)] <- h[which(h >= 360)] - 360
      h[which(h < 0)] <- h[which(h < 0)] + 360
      if (miss_c)
        c <- 65
      if (miss_l)
        l <- 55
      pal <- hcl(h, c, l, fixup = fixup)[1:n]
      lbl <- .fmt(h, 0)
      ttl <- paste("HCL Color Palette for\\n", "Chroma=", c,
                   " Luminance=", l)
  }
  else if (kind == "sequential") {
    if (miss_c)
      c <- c(35, 75)
    txt.c <- .fmt(c[1], 0)
    if (length(c) > 1)
      txt.c <- paste(txt.c, " to ", .fmt(c[2], 0), sep = "")
    l.dk <- 36 - (3 * n)
    if (l.dk < 14)
      l.dk <- 14
    l.lt <- 48 + (5 * n)
    if (l.lt > 92)
      l.lt <- 92
    if (miss_l)
      l <- c(l.lt, l.dk)
    txt.l <- .fmt(l[1], 0)
    if (length(l) > 1)
      txt.l <- paste(txt.l, " to ", .fmt(l[2], 0), sep = "")
    if (is.null(power))
      power <- 1
    pal <- sequential_hcl(n, h = h, c. = c, l = l, power = power,
                          fixup = fixup, alpha = 1)
    ttl <- paste("Sequential Colors for\\n", "h=", .fmt(h,
                                                        0), ", c=", txt.c, ",  l=", txt.l, sep = "")
  }
  else if (kind == "divergent") {
    h <- c(h, h2)
    txt.h <- .fmt(h[1], 0)
    if (length(h) > 1)
      txt.h <- paste(txt.h, " to ", .fmt(h[2], 0), sep = "")
    if (miss_c)
      c <- 50
    txt.c <- .fmt(c, 0)
    if (length(c) > 1)
      txt.c <- paste(txt.c, " to ", .fmt(c[2], 0), sep = "")
    if (miss_l)
      l <- c(30, 80)
    txt.l <- .fmt(l[1], 0)
    if (length(l) > 1)
      txt.l <- paste(txt.l, " to ", .fmt(l[2], 0), sep = "")
    if (is.null(power))
      power <- 0.75
    pal <- colorspace::diverge_hcl(n, h = h, c = c, l = l, power = power,
                                   fixup = fixup, alpha = 1)
    ttl <- paste("Divergent Colors for\\n", "h=", txt.h, ", c=",
                 txt.c, ",  l=", txt.l, sep = "")
  }
  else if (kind == "viridis") {
    ttl <- paste("A viridis Color Palette for:", pal[1],
                 "\\n")
    fn <- paste(pal[1], "(", n, ")", sep = "")
    pal <- eval(parse(text = fn))
  }
  else if (kind == "wes") {
    ttl <- paste("A Wes Anderson Color Palette for:", pal[1],
                 "\\n")
    pal <- wes_palette(pal[1], n, type = "continuous")
  }
  else if (kind == "distinct") {
    ttl <- paste("Colors Palette", pal[1], "\\n")
    pal <- c(getColors(c = 90, l = 50, n = 5), "goldenrod2",
             "gray45", "yellowgreen", "orchid3", "skyblue", "darkgray",
             "lightcoral", "navajowhite4", "cyan3", "darkorange3",
             "maroon3", "mediumaquamarine", "royalblue1", "mistyrose4",
             "thistle3")
    if (n <= 20)
      pal <- pal[1:n]
    else {
      print(pal[1:20])
      cat("\\n")
      stop(call. = FALSE, "\\n", "------\\n", "Only 20 distinct colors available.\\n",
           "Can start with a vector of the above 20 colors, then add more.\\n\\n")
    }
  }
  else if (kind == "manual.s") {
    color_palette <- colorRampPalette(c(pal, end_pal))
    pal <- color_palette(n)
    ttl <- "Custom Color Sequence"
  }
  else if (kind == "manual.q") {
    n <- length(pal)
    j <- 0
    for (i in 1:(n)) {
      j <- j + 1
      if (j > length(pal))
        j <- 1
      pal[i] <- pal[j]
    }
    ttl <- ""
  }
  else if (kind == "seq.R") {
    if (pal == "rainbow") {
      pal <- rainbow(n)
      ttl <- "Rainbow Colors"
    }
    else if (pal == "terrain") {
      pal <- terrain.colors(n)
      ttl <- "Terrain Colors"
    }
    else if (pal == "heat") {
      pal <- heat.colors(n)
      ttl <- "Heat Colors"
    }
  }
  if (lbl[1] == "")
    lbl <- pal
  go.out <- NULL
  if (!is.null(output)) {
    if (output == "on")
      go.out <- TRUE
    if (output == "off")
      go.out <- FALSE
  }
  if (is.null(go.out)) {
    if (is.null(options()$knitr.in.progress))
      go.out <- ifelse(sys.nframe() == 1, TRUE, FALSE)
    else go.out <- ifelse(sys.nframe() == 19, TRUE, FALSE)
  }
  if (trans > 0)
    for (i in 1:length(pal)) pal[i] <- .maketrans(pal[i],
                                                  (1 - trans) * 256)
  if (go.out) {
    if (!labels)
      lbl <- NA
    par(bg = getOption("panel_fill"))
    if (shape == "wheel") {
      par(mai = c(0.4, 0.5, 0.8, 0.5))
      pin <- par("pin")
      xlim <- c(-1, 1)
      ylim <- c(-1, 1)
      if (pin[1L] > pin[2L])
        xlim <- (pin[1L]/pin[2L]) * xlim
      else ylim <- (pin[2L]/pin[1L]) * ylim
      plot.window(xlim, ylim, "", asp = 1)
      pie(rep(1, length(pal)), col = pal, radius = radius,
          labels = lbl, border = border, lty = lty, cex = labels_cex)
    }
    else if (shape == "rectangle") {
      if (labels) {
        if (kind == "qualitative") {
          rotate_x <- 0
          bm <- 0.05
          bm.tx <- 0
        }
        else {
          rotate_x <- 90
          bm <- 0.24
          bm.tx <- 0.1
        }
      }
      else {
        rotate_x <- 0
        bm <- 0
        bm.tx <- 0
      }
      plot(0, 0, type = "n", xlim = c(0, 1), ylim = c(0,
                                                      1), axes = FALSE, xlab = "", ylab = "")
      rect(0:(n - 1)/n, bm, 1:n/n, 1, col = pal, border = border)
      text(0:(n - 1)/n + 1/(2 * n), bm.tx, labels = lbl[1:n],
           srt = rotate_x, cex = labels_cex)
    }
    main.lab <- ifelse(is.null(main), ttl, main)
    title(main = main.lab, cex.main = getOption("main_cex"),
          col.main = getOption("main_color"), ...)
    if (!quiet) {
      mc <- max(nchar(pal))
      cat("\\n")
      if (kind %in% c("qualitative", "sequential")) {
        if (kind == "sequential") {
          hh <- h[1]
          h <- integer(length(n))
          for (i in 1:n) h[i] <- hh
        }
        cat("      h    hex      r    g    b\\n")
        cat("-------------------------------\\n")
        for (i in 1:length(pal)) cat(.fmt(i, 0, w = 2),
                                     " ", .fmt(h[i], 0, w = 3), pal[i], .fmt(col2rgb(pal[i])[1],
                                                                             0, w = 4), .fmt(col2rgb(pal[i])[2], 0, w = 4),
                                     .fmt(col2rgb(pal[i])[3], 0, w = 4), "\\n")
      }
      else {
        cat("  color    r    g    b\\n")
        cat("----------------------\\n")
        for (i in 1:length(pal)) cat(.fmtc(pal[i], w = mc,
                                           j = "left"), .fmt(col2rgb(pal[i])[1], 0, w = 4),
                                     .fmt(col2rgb(pal[i])[2], 0, w = 4), .fmt(col2rgb(pal[i])[3],
                                                                              0, w = 4), "\\n")
      }
    }
    cat("\\n")
  }
  invisible(pal)
}

.fmt = function (k, d = getOption("digits_d"), w = 0, j = "right")
{
  format(sprintf("%.*f", d, k), width = w, justify = j, scientific = FALSE)
}
