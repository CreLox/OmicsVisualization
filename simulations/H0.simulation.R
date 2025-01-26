H0.simulation <- function(n = 6, N = 5e5, meanlog = 5, sdlog = 1, sdo = 0.9, sdf = 0.2) {
  minus.lg.pvalue <- rep(NA, N)
  log2.FC <- rep(NA, N)
  log2.base.mean <- rep(NA, N)
  Out <- as.data.frame(cbind(log2.FC, minus.lg.pvalue, log2.base.mean))
  
  GroupMean <- rlnorm(N, meanlog = meanlog, sdlog = sdlog)
  for (i in 1 : N) {
    group1 <- rnorm(n, mean = GroupMean[i], sd = GroupMean[i] ^ sdo * sdf)
    group2 <- rnorm(n, mean = GroupMean[i], sd = GroupMean[i] ^ sdo * sdf)
    Out$log2.FC[i] <- log2(mean(group1)/mean(group2))
    Out$minus.lg.pvalue[i] <- -log10(t.test(x = group1, y = group2, var.equal = TRUE)$p.value)
    Out$log2.base.mean[i] <- log2(mean(c(group1, group2)))
  }
  # Out$minus.lg.padj <- -log10(p.adjust(10^(-Out$minus.lg.pvalue), method = "fdr"))
  
  # Plot <- ggplot(data = Out, aes(x = log2.FC, y = minus.lg.pvalue)) +
  #         geom_point(alpha = 0.25, stroke = 0) +
  #         geom_density_2d(bins = 100) +
  #         geom_hline(yintercept = -log10(0.05), linetype = "dashed", linewidth = 0.25) +
  #         xlab(bquote(log[2](FC))) + ylab(bquote(-log[10](italic(p)))) +
  #         theme_bw() + theme(legend.position = "none", panel.grid.minor = element_blank(), panel.grid.major = element_blank()) +
  #         coord_cartesian(expand = FALSE, clip = "off")
  # print(Plot)

  return(Out)
}
