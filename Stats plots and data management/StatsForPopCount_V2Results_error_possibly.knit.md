
<!-- rnb-text-begin -->

---
title: "R Notebook"
output: html_notebook
---
#Source for popcount

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1ByZXBhcmluZyB0aGUgZGF0YSBhbmQgdGhlIGZ1bmN0aW9uXG5wb3AgPSByZWFkLmNzdihcIkM6L0xhcHRvcCBCYWNrdXBzL0hvbWVzdGF0aWNFeHBhbnNpb25Qcm9qZWN0L01vZGVsRGF0YS9BZnRlckNhbGN1bGF0aW9ucy5jc3ZcIilcbkFjdFQgPSByZWFkLmNzdignQzovTGFwdG9wIEJhY2t1cHMvSG9tZXN0YXRpY0V4cGFuc2lvblByb2plY3QvTW9kZWxEYXRhL1RDZWxsQWN0aXZhdGlvblN1bW1hcnlfZmlsbGVkLmNzdicpXG5BY3RUJEdlbm90eXBlW0FjdFQkR2Vub3R5cGUgPT0gXCJJTC0yLUtPXCJdID0gXCJLT1wiXG5BY3RUJEdlbm90eXBlW0FjdFQkR2Vub3R5cGUgPT0gXCJJTC0yLUhFVFwiXSA9IFwiV1RcIlxuQWN0VCRHZW5vdHlwZVtBY3RUJEdlbm90eXBlID09IFwiQ0QyNS1LT1wiXSA9IFwiS09cIlxuQWN0VCA9IEFjdFRbIShBY3RUJEdlbm90eXBlID09IFwiXCIpLF1cbmxpYnJhcnkoZ2dwbG90MilcbmBgYCJ9 -->

```r
#Preparing the data and the function
pop = read.csv("C:/Laptop Backups/HomestaticExpansionProject/ModelData/AfterCalculations.csv")
ActT = read.csv('C:/Laptop Backups/HomestaticExpansionProject/ModelData/TCellActivationSummary_filled.csv')
ActT$Genotype[ActT$Genotype == "IL-2-KO"] = "KO"
ActT$Genotype[ActT$Genotype == "IL-2-HET"] = "WT"
ActT$Genotype[ActT$Genotype == "CD25-KO"] = "KO"
ActT = ActT[!(ActT$Genotype == ""),]
library(ggplot2)
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


Some info on the 'pop' dataset
- 1:18 - meta data associated with the experiment that generated the data
- 18:42 - Individual events counted/selected by the FCS express at the appropriate gate
- 43 - Age in integer format; Age(pop[,14]) is a column with the ages saved as factors for the purposes of creating the plots that I first made.
- 44+ - All calculations created from either 'popcount_V2.R' or this R script. E-mail jonazule@gmail.com if there is any confusion. 

#Doing t tests on the ages

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI0Z1bmN0aW9uc1xuYWdlVHRlc3QgPSBmdW5jdGlvbihjb2x1bW4sIGFsdGVybmF0aXZlLCBkZiwgb3JnYW4pe1xuICBhZ2UgPSBjKDAsNCw3LDksMTIsMTQsMTgpXG4gIHJlc3VsdHMgPSBkYXRhLmZyYW1lKG1hdHJpeChuY29sID0gMiwgbnJvdyA9IDApKVxuICBjb2xuYW1lcyhyZXN1bHRzKSA8LSBjKFwiQWdlXCIsIFwiUHZhbHVlXCIpXG4gICNEbyBub3QgY2hhbmdlIHRoZSBuYW1lIG9mIHBvcCBkYXRhZnJhbWUgaW4gcG9wQ291bnRfVjIuUiBzY3JpcHRcbiAgZm9yIChpIGluIGFnZSl7XG4gICAgd3QgPSBzdWJzZXQoZGYsIGludGFnZSA9PSBpICYgR2Vub3R5cGUgPT0gXCJXVFwiICYgT3JnYW4gPT0gb3JnYW4sIHNlbGVjdCA9IGNvbHVtbilcbiAgICBrbyA9IHN1YnNldChkZiwgaW50YWdlID09IGkgJiBHZW5vdHlwZSA9PSBcIktPXCIgJiBPcmdhbiA9PSBvcmdhbiwgc2VsZWN0ID0gY29sdW1uKVxuICAgIHR0ID0gdC50ZXN0KHd0LCBrbywgYWx0ZXJuYXRpdmUgPSBhbHRlcm5hdGl2ZSlcbiAgICByZXN1bHRzW25yb3cocmVzdWx0cykrMSxdIDwtIGMoaSwgdHQkcC52YWx1ZSlcbiAgfVxuICByZXR1cm4ocmVzdWx0cylcbn1cblxuYWdlVHRlc3RjZDQ0ID0gZnVuY3Rpb24oY29sdW1uLCBhbHRlcm5hdGl2ZSwgZGYpe1xuICBhZ2UgPSBjKDAsNCw3LDksMTIsMTQsMTgpXG4gIHJlc3VsdHMgPSBkYXRhLmZyYW1lKG1hdHJpeChuY29sID0gMiwgbnJvdyA9IDApKVxuICBjb2xuYW1lcyhyZXN1bHRzKSA8LSBjKFwiQWdlXCIsIFwiUHZhbHVlXCIpXG4gICNEbyBub3QgY2hhbmdlIHRoZSBuYW1lIG9mIHBvcCBkYXRhZnJhbWUgaW4gcG9wQ291bnRfVjIuUiBzY3JpcHRcbiAgZm9yIChpIGluIGFnZSl7XG4gICAgd3QgPSBzdWJzZXQoZGYsIEFnZSA9PSBpICYgR2Vub3R5cGUgPT0gXCJXVFwiLCBzZWxlY3QgPSBjb2x1bW4pXG4gICAga28gPSBzdWJzZXQoZGYsIEFnZSA9PSBpICYgR2Vub3R5cGUgPT0gXCJLT1wiLCBzZWxlY3QgPSBjb2x1bW4pXG4gICAgdHQgPSB0LnRlc3Qod3QsIGtvLCBhbHRlcm5hdGl2ZSA9IGFsdGVybmF0aXZlKVxuICAgIHByaW50KHR0KVxuICAgIHJlc3VsdHNbbnJvdyhyZXN1bHRzKSsxLF0gPC0gYyhpLCB0dCRwLnZhbHVlKVxuICB9XG4gIHJldHVybihyZXN1bHRzKVxufVxuXG5hZ2VUdGVzdDIgPSBmdW5jdGlvbihjb2x1bW4sIGFsdGVybmF0aXZlLCBkZnd0LCBkZmtvLCBvcmdhbil7XG4gIGFnZSA9IGMoMCw0LDcsOSwxMiwxNCwxOClcbiAgcmVzdWx0cyA9IGRhdGEuZnJhbWUobWF0cml4KG5jb2wgPSAyLCBucm93ID0gMCkpXG4gIGNvbG5hbWVzKHJlc3VsdHMpIDwtIGMoXCJBZ2VcIiwgXCJQdmFsdWVcIilcbiAgI0RvIG5vdCBjaGFuZ2UgdGhlIG5hbWUgb2YgcG9wIGRhdGFmcmFtZSBpbiBwb3BDb3VudF9WMi5SIHNjcmlwdFxuICBmb3IgKGkgaW4gYWdlKXtcbiAgICB3dCA9IHN1YnNldChkZnd0LCBpbnRhZ2UgPT0gaSAmIEdlbm90eXBlID09IFwiV1RcIiwgc2VsZWN0ID0gY29sdW1uKVxuICAgIGtvID0gc3Vic2V0KGRma28sIGludGFnZSA9PSBpICYgR2Vub3R5cGUgPT0gXCJLT1wiLCBzZWxlY3QgPSBjb2x1bW4pXG4gICAgdHQgPSB0LnRlc3Qod3QsIGtvLCBhbHRlcm5hdGl2ZSA9IGFsdGVybmF0aXZlKVxuICAgIHJlc3VsdHNbbnJvdyhyZXN1bHRzKSsxLF0gPC0gYyhpLCB0dCRwLnZhbHVlKVxuICB9XG4gIHJldHVybihyZXN1bHRzKVxufVxuXG5gYGAifQ== -->

```r
#Functions
ageTtest = function(column, alternative, df, organ){
  age = c(0,4,7,9,12,14,18)
  results = data.frame(matrix(ncol = 2, nrow = 0))
  colnames(results) <- c("Age", "Pvalue")
  #Do not change the name of pop dataframe in popCount_V2.R script
  for (i in age){
    wt = subset(df, intage == i & Genotype == "WT" & Organ == organ, select = column)
    ko = subset(df, intage == i & Genotype == "KO" & Organ == organ, select = column)
    tt = t.test(wt, ko, alternative = alternative)
    results[nrow(results)+1,] <- c(i, tt$p.value)
  }
  return(results)
}

ageTtestcd44 = function(column, alternative, df){
  age = c(0,4,7,9,12,14,18)
  results = data.frame(matrix(ncol = 2, nrow = 0))
  colnames(results) <- c("Age", "Pvalue")
  #Do not change the name of pop dataframe in popCount_V2.R script
  for (i in age){
    wt = subset(df, Age == i & Genotype == "WT", select = column)
    ko = subset(df, Age == i & Genotype == "KO", select = column)
    tt = t.test(wt, ko, alternative = alternative)
    print(tt)
    results[nrow(results)+1,] <- c(i, tt$p.value)
  }
  return(results)
}

ageTtest2 = function(column, alternative, dfwt, dfko, organ){
  age = c(0,4,7,9,12,14,18)
  results = data.frame(matrix(ncol = 2, nrow = 0))
  colnames(results) <- c("Age", "Pvalue")
  #Do not change the name of pop dataframe in popCount_V2.R script
  for (i in age){
    wt = subset(dfwt, intage == i & Genotype == "WT", select = column)
    ko = subset(dfko, intage == i & Genotype == "KO", select = column)
    tt = t.test(wt, ko, alternative = alternative)
    results[nrow(results)+1,] <- c(i, tt$p.value)
  }
  return(results)
}

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1QgdGVzdCBidWxrIGFnZXNcbkJ1bGtUZXN0V2l0aEFnZUN1dG9mZiA9IGZ1bmN0aW9uKGNvbHVtbiwgYWdlLCBsZXNzT3JHcmVhdGVyID0gXCJHcmVhdGVyXCIpe1xuICAjZGF0YSB3aWxsIGFsd2F5cyBiZSBwb3BcbiAgIyBhZ2VzIGFyZSBhZ2UgPSBjKDAsNCw3LDksMTIsMTQsMTgpXG4gIGlmIChsZXNzT3JHcmVhdGVyID09IFwibGVzc1wiKXtcbiAgICB3dCA9IHN1YnNldChwb3AsIGludGFnZSA8PSBhZ2UgJiBHZW5vdHlwZSA9PSBcIldUXCIpXG4gICAga28gPSBzdWJzZXQocG9wLCBpbnRhZ2UgPD0gYWdlICYgR2Vub3R5cGUgPT0gXCJLT1wiKVxuICB9IGVsc2Uge1xuICAgIHd0ID0gc3Vic2V0KHBvcCwgaW50YWdlID49IGFnZSAmIEdlbm90eXBlID09IFwiV1RcIiAmIGludGFnZSA8IDU2IClcbiAgICBrbyA9IHN1YnNldChwb3AsIGludGFnZSA+PSBhZ2UgJiBHZW5vdHlwZSA9PSBcIktPXCIgJiBpbnRhZ2UgPCA1NilcbiAgfVxuICByZXN1bHRzID0gdC50ZXN0KHd0W1tjb2x1bW5dXSwga29bW2NvbHVtbl1dLCBhbHRlcm5hdGl2ZSA9IFwidHdvLnNpZGVkXCIpXG4gIHJldHVybihyZXN1bHRzKVxufVxuXG5gYGAifQ== -->

```r
#T test bulk ages
BulkTestWithAgeCutoff = function(column, age, lessOrGreater = "Greater"){
  #data will always be pop
  # ages are age = c(0,4,7,9,12,14,18)
  if (lessOrGreater == "less"){
    wt = subset(pop, intage <= age & Genotype == "WT")
    ko = subset(pop, intage <= age & Genotype == "KO")
  } else {
    wt = subset(pop, intage >= age & Genotype == "WT" & intage < 56 )
    ko = subset(pop, intage >= age & Genotype == "KO" & intage < 56)
  }
  results = t.test(wt[[column]], ko[[column]], alternative = "two.sided")
  return(results)
}

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-frame-begin eyJtZXRhZGF0YSI6eyJjbGFzc2VzIjpbImRhdGEuZnJhbWUiXSwibnJvdyI6NywibmNvbCI6Miwic3VtbWFyeSI6eyJEZXNjcmlwdGlvbiI6WyJkZiBbNyDDlyAyXSJdfX0sInJkZiI6Ikg0c0lBQUFBQUFBQUJndHlpVERtaXVCaVlHQmdabUJoWW1SZ1pnVXlHVmhEUTl4MExSaUFJa0FPSXdNTEF5ZUlyZ0FxRWdZeVFJSjhRTXpPQUFVT0FsQmFCa29yUVdrTktLMERwWTFnT2lENjdTOTl5UHBlOVZ2SGZzRzZaWmxwNHFMMkMwMmVUdm5YZHNmZTVXWlBWWjRTcS8zR0pYTVdlejgrYkQveFpGN09kaHNsKzB6T0R6dzZlbTVvRG1QTlM4eE5MUVl5Qk1DT2d3Z3lPNmFuUXBsc0FXV0pPYVdwYUxvNGkvTEw5V0E2ZVVFNkd5Qk9ZMGMzUGprbnNSaG1QRXlRS3lXeEpGRXZyUWlvSDhqN2g2YUZQYitnSkRNL0Q2aUpDUlJnckdpYUdZdlFCUGhMODBBdVNkRk56aWpOeTlZMUJGa0Fsb1pnWGlqTmpzUm1nbGpKOUI5cUZDdk1zNmw1NlpsNU1LK3o1aVFtcGVaQU9YeEFINE05ckZkUWxKbFhBdk1KVUxSWXJ5Uy9KQkdtamlzNVB3Y21Bdllid3o4QVh5TFpvaWNDQUFBPSJ9 -->

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["Age"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["Pvalue"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"0","2":"0.2959239404","_rn_":"1"},{"1":"4","2":"0.0325824741","_rn_":"2"},{"1":"7","2":"0.0336066956","_rn_":"3"},{"1":"9","2":"0.0006362854","_rn_":"4"},{"1":"12","2":"0.0689180278","_rn_":"5"},{"1":"14","2":"0.0173699621","_rn_":"6"},{"1":"18","2":"0.0030564965","_rn_":"7"}],"options":{"columns":{"min":{},"max":[10],"total":[2]},"rows":{"min":[10],"max":[10],"total":[7]},"pages":{}}}
  </script>
</div>

<!-- rnb-frame-end -->

<!-- rnb-chunk-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuYWdlVHRlc3RjZDQ0ID0gZnVuY3Rpb24oY29sdW1uLCBhbHRlcm5hdGl2ZSwgZGYpe1xuICBhZ2UgPSBjKDAsNCw5LDEyLDE0LDE4KVxuICByZXN1bHRzID0gZGF0YS5mcmFtZShtYXRyaXgobmNvbCA9IDIsIG5yb3cgPSAwKSlcbiAgY29sbmFtZXMocmVzdWx0cykgPC0gYyhcIkFnZVwiLCBcIlB2YWx1ZVwiKVxuICAjRG8gbm90IGNoYW5nZSB0aGUgbmFtZSBvZiBwb3AgZGF0YWZyYW1lIGluIHBvcENvdW50X1YyLlIgc2NyaXB0XG4gIGZvciAoaSBpbiBhZ2Upe1xuICAgIHd0ID0gc3Vic2V0KGRmLCBBZ2UgPT0gaSAmIEdlbm90eXBlID09IFwiV1RcIiwgc2VsZWN0ID0gY29sdW1uKVxuICAgIGtvID0gc3Vic2V0KGRmLCBBZ2UgPT0gaSAmIEdlbm90eXBlID09IFwiS09cIiwgc2VsZWN0ID0gY29sdW1uKVxuICAgIHR0ID0gdC50ZXN0KHd0LCBrbywgYWx0ZXJuYXRpdmUgPSBhbHRlcm5hdGl2ZSlcbiAgICByZXN1bHRzW25yb3cocmVzdWx0cykrMSxdIDwtIGMoaSwgdHQkcC52YWx1ZSlcbiAgfVxuICByZXR1cm4ocmVzdWx0cylcbn1cblxuXG5hZ2VUdGVzdGNkNDQoXCJwY3RfQ0Q0X0NENDRfcG9zX0NENjJMX25lZ1wiLCBcImxlc3NcIiwgQWN0VClcbmBgYCJ9 -->

```r
ageTtestcd44 = function(column, alternative, df){
  age = c(0,4,9,12,14,18)
  results = data.frame(matrix(ncol = 2, nrow = 0))
  colnames(results) <- c("Age", "Pvalue")
  #Do not change the name of pop dataframe in popCount_V2.R script
  for (i in age){
    wt = subset(df, Age == i & Genotype == "WT", select = column)
    ko = subset(df, Age == i & Genotype == "KO", select = column)
    tt = t.test(wt, ko, alternative = alternative)
    results[nrow(results)+1,] <- c(i, tt$p.value)
  }
  return(results)
}


ageTtestcd44("pct_CD4_CD44_pos_CD62L_neg", "less", ActT)
```

<!-- rnb-source-end -->

<!-- rnb-frame-begin eyJtZXRhZGF0YSI6eyJjbGFzc2VzIjpbImRhdGEuZnJhbWUiXSwibnJvdyI6NiwibmNvbCI6Miwic3VtbWFyeSI6eyJEZXNjcmlwdGlvbiI6WyJkZiBbNiDDlyAyXSJdfX0sInJkZiI6Ikg0c0lBQUFBQUFBQUJndHlpVERtaXVCaVlHQmdabUJoWW1SZ1pnVXlHVmhEUTl4MExSaUFJa0FPSXdNTEF5ZUlyZ0FxRWdZeVFJSjhRTXpHQUFVT0FsQmFDVXByUUdrZEtHMEVVd25SWjc5SGF4bnYrdi9WOW05ZXVqeTlZWjF2LzBKRm91U1hTYVI5SksvdWxsQnZkdnVtRmxubFB4UHQ3TFBOT1FLZEsvblFITUthbDVpYldneGtDSUFkQXhGa2RreFBoVExaQXNvU2MwcFQwWFJ4RnVXWDY4RjA4b0owTmtDY3hJWnVmSEpPWWpITWVKZ2dWMHBpU2FKZVdoRlFQNUQzRDAwTGUzNUJTV1orSGxBVEV5aUFXTkUwTXhhaENRaVU1b0Zja3FLYm5GR2FsNjFyYWdteUFTd1B3YnhRbWcySnpRU3hrK2svMUN4V21HOVQ4OUl6ODJCK1o4MUpURXJOZ1hMNGdGNEcrMWl2b0NnenJ3VG1GYUJvc1Y1SmZra2lUQjFYY240T1RBVHNPWVovQUV1MkNlZ1lBZ0FBIn0= -->

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["Age"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["Pvalue"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"0","2":"0.110025767","_rn_":"1"},{"1":"4","2":"0.903475236","_rn_":"2"},{"1":"9","2":"0.754406193","_rn_":"3"},{"1":"12","2":"0.001529021","_rn_":"4"},{"1":"14","2":"0.009041050","_rn_":"5"},{"1":"18","2":"0.003322140","_rn_":"6"}],"options":{"columns":{"min":{},"max":[10],"total":[2]},"rows":{"min":[10],"max":[10],"total":[6]},"pages":{}}}
  </script>
</div>

<!-- rnb-frame-end -->

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuIyB0YWJsZShBY3RUJEFnZSlcbiMgXG4jIFdUMTIgPSBzdWJzZXQoQWN0VCwgQWdlID09IDcgJiBHZW5vdHlwZSA9PSBcIldUXCIsIHNlbGVjdCA9IFwicGN0X0NENF9DRDQ0X3Bvc19DRDYyTF9uZWdcIilcbiMgS08xMiA9IHN1YnNldChBY3RULCBBZ2UgPT0gNyAmIEdlbm90eXBlID09IFwiS09cIiwgc2VsZWN0ID0gXCJwY3RfQ0Q0X0NENDRfcG9zX0NENjJMX25lZ1wiKVxuIyBcbiMgdC50ZXN0KFdUMTIsIEtPMTIsIGFsdGVybmF0aXZlID0gXCJsZXNzXCIpXG5cbmBgYCJ9 -->

```r
# table(ActT$Age)
# 
# WT12 = subset(ActT, Age == 7 & Genotype == "WT", select = "pct_CD4_CD44_pos_CD62L_neg")
# KO12 = subset(ActT, Age == 7 & Genotype == "KO", select = "pct_CD4_CD44_pos_CD62L_neg")
# 
# t.test(WT12, KO12, alternative = "less")

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuYWdlVHRlc3QyKFwiWDRUcmVnUHJvbENUXCIsIFwibGVzc1wiLCBXVFByb2wsIEtPUHJvbClcblxuYGBgIn0= -->

```r
ageTtest2("X4TregProlCT", "less", WTProl, KOProl)

```

<!-- rnb-source-end -->

<!-- rnb-output-begin eyJkYXRhIjoiWzFdIDRcblsxXSA3XG5bMV0gOVxuWzFdIDEyXG5bMV0gMTRcblsxXSAxOFxuIn0= -->

```
[1] 4
[1] 7
[1] 9
[1] 12
[1] 14
[1] 18
```



<!-- rnb-output-end -->

<!-- rnb-frame-begin eyJtZXRhZGF0YSI6eyJjbGFzc2VzIjpbImRhdGEuZnJhbWUiXSwibnJvdyI6NiwibmNvbCI6Miwic3VtbWFyeSI6eyJEZXNjcmlwdGlvbiI6WyJkZiBbNiDDlyAyXSJdfX0sInJkZiI6Ikg0c0lBQUFBQUFBQUJndHlpVERtaXVCaVlHQmdabUJoWW1SZ1pnVXlHVmhEUTl4MExSaUFJa0FPSXdNTEF5ZUlyZ0FxRWdZeVFJSjhRTXptSU1BQUJnNHlVRm9KU210QWFSMG9iY1FBQTJCOTltL05sZjY4bS9MVC9uMVRrMjl5VlpqOSsvZmVFYXN6USswdlRQaDh6djFDcnYzMWtEZjdMM2crc3I5Y2JwbktHU1NENWhEV3ZNVGMxR0lnUXdEc0dJZ2dzMk42S3BUSkZsQ1dtRk9haXFhTHN5aS9YQStta3hla3N3SGlKRFowNDVOekVvdGh4c01FdVZJU1N4TDEwb3FBK29HOGYyaGEyUE1MU2pMejg0Q2FtRUFCeElxbW1iRUlUVUNnTkEva2toVGQ1SXpTdkd4ZGMwT1FEV0I1Q09hRjBteEliQ2FJblV6L29XYXh3bnlibXBlZW1RZnpPMnRPWWxKcURwVERCL1F5Mk1kNkJVV1plU1V3cndCRmkvVks4a3NTWWVxNGt2TnpZQ0pnenpIOEF3QzFjR2t0R0FJQUFBPT0ifQ== -->

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["Age"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["Pvalue"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"4","2":"0.9129806","_rn_":"1"},{"1":"7","2":"0.9846813","_rn_":"2"},{"1":"9","2":"0.9979607","_rn_":"3"},{"1":"12","2":"0.2588472","_rn_":"4"},{"1":"14","2":"0.3645584","_rn_":"5"},{"1":"18","2":"0.3041519","_rn_":"6"}],"options":{"columns":{"min":{},"max":[10],"total":[2]},"rows":{"min":[10],"max":[10],"total":[6]},"pages":{}}}
  </script>
</div>

<!-- rnb-frame-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1QudGVzdCBmb3Igb3JnYW5zXG5WaWV3KHBvcClcbnNwbGVlbiA9IHN1YnNldChwb3AsIE9yZ2FuID09IFwiU3BsZWVuXCIpXG50aHltdXMgPSBzdWJzZXQocG9wLCBPcmdhbiA9PSBcIlRoeW11c1wiKVxuXG5hZ2VUdGVzdChcIk9yZ2FuV2VpZ2h0XCIsIFwibGVzc1wiLCBzcGxlZW4pXG5cbmFnZVR0ZXN0KFwiT3JnYW5XZWlnaHRcIiwgXCJsZXNzXCIsIHRoeW11cylcblxubnJvdyhzcGxlZW4pXG5ucm93KHRoeW11cylcbm5yb3cocG9wKVxuYGBgIn0= -->

```r
#T.test for organs
View(pop)
spleen = subset(pop, Organ == "Spleen")
thymus = subset(pop, Organ == "Thymus")

ageTtest("OrganWeight", "less", spleen)

ageTtest("OrganWeight", "less", thymus)

nrow(spleen)
nrow(thymus)
nrow(pop)
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->




<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1B1bGxpbmcgb3V0IHRoZSBjb3VudHMgdGhhdCB3ZXJlIG5vdCBwcm9saWZlcmF0aW5nXG5wb3AkQ0Q0bm9uUHJvbGlmZXJhdGluZ19DVCA9IHBvcCRDRDRDVCAtIHBvcCRDRDRQcm9sQ1RcbmFnZVR0ZXN0KFwiQ0Q0bm9uUHJvbGlmZXJhdGluZ19DVFwiKVxuYGBgIn0= -->

```r
#Pulling out the counts that were not proliferating
pop$CD4nonProliferating_CT = pop$CD4CT - pop$CD4ProlCT
ageTtest("CD4nonProliferating_CT")
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI0xvb2tpbmcgdG8gc2VlIHRoZSByYXRpbyBvZiBub24gYWN0aXZhdGVkXG5wb3AkQ0Q0bm9uUHJvbGlmZXJhdGluZ19SYXRpbyA9IHBvcCRDRDRub25Qcm9saWZlcmF0aW5nX0NUL3BvcCRDRDRDVFxuc3VtbWFyeShwb3AkQ0Q0bm9uUHJvbGlmZXJhdGluZ2RfUmF0aW8pXG5oaXN0KHBvcCRDRDRub25Qcm9saWZlcmF0aW5nX1JhdGlvLCBicmVha3MgPSBzZXEoMCwxLDAuMDEpKVxubG93RnJlcSA9IHN1YnNldChwb3AsIENENG5vblByb2xpZmVyYXRpbmdfUmF0aW8gPD0gMC41KVxuaGlnaEZyZXEgPSBzdWJzZXQocG9wLCBDRDRub25Qcm9saWZlcmF0aW5nX1JhdGlvID49IDAuNSlcbmhpc3QobG93RnJlcSRpbnRhZ2UpXG5oaXN0KGhpZ2hGcmVxJGludGFnZSlcblxuI1dlIGhhdmUgYSBoaWdoIG51bWJlciBvZiBub24gYWN0aXZhdGlvbiBpbiB0aGUgYWdlcyBhYm92ZSAxMFxuYGBgIn0= -->

```r
#Looking to see the ratio of non activated
pop$CD4nonProliferating_Ratio = pop$CD4nonProliferating_CT/pop$CD4CT
summary(pop$CD4nonProliferatingd_Ratio)
hist(pop$CD4nonProliferating_Ratio, breaks = seq(0,1,0.01))
lowFreq = subset(pop, CD4nonProliferating_Ratio <= 0.5)
highFreq = subset(pop, CD4nonProliferating_Ratio >= 0.5)
hist(lowFreq$intage)
hist(highFreq$intage)

#We have a high number of non activation in the ages above 10
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI0hpZ2ggbm9uIGFjdGl2YXRpb24gZGlmZmVyZW5jZSBiZXR3ZWVuIFdUIGFuZCBLT1xuI0hpZ2ggbnVtYmVycyBvZiBub24gYWN0aXZhdGVkIGNlbGxzXG5oaWdoTm9uUHJvbFdUID0gc3Vic2V0KHBvcCwgQ0Q0bm9uUHJvbGlmZXJhdGluZ19SYXRpbyA+PSAwLjUgJiBHZW5vdHlwZSA9PSBcIldUXCIpXG5oaWdoTm9uUHJvbEtPID0gc3Vic2V0KHBvcCwgQ0Q0bm9uUHJvbGlmZXJhdGluZ19SYXRpbyA+PSAwLjUgJiBHZW5vdHlwZSA9PSBcIktPXCIpXG5wYXIobWZyb3c9YygxLDIpKVxuaGlzdChoaWdoTm9uUHJvbEtPJGludGFnZSwgbWFpbiA9IFwiSGlnbk5vblByb2wgS09cIilcbmhpc3QoaGlnaE5vblByb2xXVCRpbnRhZ2UsIG1haW4gPSBcIkhpZ25Ob25Qcm9sIFdUXCIpXG50LnRlc3QoaGlnaE5vblByb2xXVCRDRDRub25BY3RpdmF0ZWRfUmF0aW8sIGhpZ2hOb25Qcm9sS08kQ0Q0bm9uQWN0aXZhdGVkX1JhdGlvLCBhbHRlcm5hdGl2ZSA9IFwidHdvLnNpZGVkXCIpXG5cbiMgYWdlVHRlc3QoXCJDRDRub25BY3RpdmF0ZWRfUmF0aW9cIilcblxuYGBgIn0= -->

```r
#High non activation difference between WT and KO
#High numbers of non activated cells
highNonProlWT = subset(pop, CD4nonProliferating_Ratio >= 0.5 & Genotype == "WT")
highNonProlKO = subset(pop, CD4nonProliferating_Ratio >= 0.5 & Genotype == "KO")
par(mfrow=c(1,2))
hist(highNonProlKO$intage, main = "HignNonProl KO")
hist(highNonProlWT$intage, main = "HignNonProl WT")
t.test(highNonProlWT$CD4nonActivated_Ratio, highNonProlKO$CD4nonActivated_Ratio, alternative = "two.sided")

# ageTtest("CD4nonActivated_Ratio")

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1Rlc3RpbmcgdG8gc2VlIHByb2xpZmVyYXRpb25cbmhpc3QocG9wJENENFByb2xSYXRpbywgbWFpbiA9IFwiUHJvbGlmZXJhdGlvbiBvZiBBbGxcIilcbmhpZ2hQcm9sV1QgPSAgc3Vic2V0KHBvcCwgQ0Q0UHJvbFJhdGlvID49IDAuNSAmIEdlbm90eXBlID09IFwiV1RcIilcbmhpZ2hQcm9sS08gPSAgc3Vic2V0KHBvcCwgQ0Q0UHJvbFJhdGlvID49IDAuNSAmIEdlbm90eXBlID09IFwiS09cIilcbnBhcihtZnJvdz1jKDEsMikpXG5oaXN0KGhpZ2hQcm9sV1QkaW50YWdlLCBtYWluID0gXCJIaWdoUHJvbCBDRDQgS09cIilcbmhpc3QoaGlnaFByb2xLTyRpbnRhZ2UsIG1haW4gPSBcIkhpZ25Qcm9sIENENCBXVFwiKVxudC50ZXN0KGhpZ2hQcm9sV1QkQ0Q0UHJvbFJhdGlvLCBoaWdoUHJvbEtPJENENFByb2xSYXRpbywgYWx0ZXJuYXRpdmUgPSBcInR3by5zaWRlZFwiKVxudC50ZXN0KGhpZ2hGcmVxV1QkQ0Q0bm9uQWN0aXZhdGVkX1JhdGlvLCBoaWdoRnJlcUtPJENENG5vbkFjdGl2YXRlZF9SYXRpbywgYWx0ZXJuYXRpdmUgPSBcInR3by5zaWRlZFwiKVxuYGBgIn0= -->

```r
#Testing to see proliferation
hist(pop$CD4ProlRatio, main = "Proliferation of All")
highProlWT =  subset(pop, CD4ProlRatio >= 0.5 & Genotype == "WT")
highProlKO =  subset(pop, CD4ProlRatio >= 0.5 & Genotype == "KO")
par(mfrow=c(1,2))
hist(highProlWT$intage, main = "HighProl CD4 KO")
hist(highProlKO$intage, main = "HignProl CD4 WT")
t.test(highProlWT$CD4ProlRatio, highProlKO$CD4ProlRatio, alternative = "two.sided")
t.test(highFreqWT$CD4nonActivated_Ratio, highFreqKO$CD4nonActivated_Ratio, alternative = "two.sided")
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1Rlc3RpbmcgdGhlIHByb2xpZmVyYXRpb24gb2YgQ0Q0cyBvZiBhZ2VzIDkgYW5kIGFib3ZlXG5wcm9sOW5HcmVhdGVyV1QgPSBzdWJzZXQocG9wLCBpbnRhZ2UgPj0gOSAmIEdlbm90eXBlID09IFwiV1RcIiAmIGludGFnZSA8IDU2IClcbnByb2w5bkdyZWF0ZXJLTyA9IHN1YnNldChwb3AsIGludGFnZSA+PSA5ICYgR2Vub3R5cGUgPT0gXCJLT1wiICYgaW50YWdlIDwgNTYgKVxudC50ZXN0KHByb2w5bkdyZWF0ZXJXVCRDRDRQcm9sUmF0aW8sIHByb2w5bkdyZWF0ZXJLTyRDRDRQcm9sUmF0aW8sIGFsdGVybmF0aXZlID0gIFwidHdvLnNpZGVkXCIpXG5gYGAifQ== -->

```r
#Testing the proliferation of CD4s of ages 9 and above
prol9nGreaterWT = subset(pop, intage >= 9 & Genotype == "WT" & intage < 56 )
prol9nGreaterKO = subset(pop, intage >= 9 & Genotype == "KO" & intage < 56 )
t.test(prol9nGreaterWT$CD4ProlRatio, prol9nGreaterKO$CD4ProlRatio, alternative =  "two.sided")
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuQnVsa1Rlc3RXaXRoQWdlQ3V0b2ZmKFwiQ0Q0UHJvbFJhdGlvXCIsOSlcbkJ1bGtUZXN0V2l0aEFnZUN1dG9mZihcIlg0VHJlZ1JhdGlvXCIsOSlcbmFnZVR0ZXN0KFwiWDRUcmVnUmF0aW9cIilcbiNUcmVncyBoYXZlIGEgc3RhdGlzdGljYWwgZGlmZmVyZW5jZXMgd2hlbiBpdCBjb21lcyB0byBhZ2UgYnkgYWdlIGF0IGFnZSA5IGFuZCA0LCBhbmQgYWxtb3N0IGF0IGRheSAxOVxuI1doZW4gYnVsa2VkIGFsbCB0cmVnIHJhdGlvIG51bWJlcnMgYWJvdmUgYWdlIDkgYXJlIHN0YXRpc3RpY2FsbHkgc2lnbmlmaWNhbnRcbmBgYCJ9 -->

```r
BulkTestWithAgeCutoff("CD4ProlRatio",9)
BulkTestWithAgeCutoff("X4TregRatio",9)
ageTtest("X4TregRatio")
#Tregs have a statistical differences when it comes to age by age at age 9 and 4, and almost at day 19
#When bulked all treg ratio numbers above age 9 are statistically significant
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


#Checking Weights of Organs and Mice

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI0NoZWNraW5nIG91dCB0aGUgU3BsZWVuIGFuZCBUaHltdXMgV2VpZ2h0c1xuVGh5bVdlaWdodCA9IHN1YnNldChwb3AsIE9yZ2FuID09IFwiVGh5bXVzXCIpXG5TcGxuV2VpZ2h0S08gPSBzdWJzZXQocG9wLCBPcmdhbiA9PSBcIlNwbGVlblwiICYgT3JnYW5XZWlnaHQgPCAwLjc5ICYgR2Vub3R5cGUgPT0gXCJLT1wiKVxuU3BsbldlaWdodFdUID0gc3Vic2V0KHBvcCwgT3JnYW4gPT0gXCJTcGxlZW5cIiAmIE9yZ2FuV2VpZ2h0IDwgMC43OSAmIEdlbm90eXBlID09IFwiV1RcIilcbiNUaGVyZSBpcyBhbiBvdXRsaWVyIGluIHRoZSBzcGxlZW4gd2VpZ2h0XG5cbnBsb3QoVGh5bVdlaWdodCRBZ2UsVGh5bVdlaWdodCRPcmdhbldlaWdodClcbnBsb3QoU3BsbldlaWdodCRBZ2UsIFNwbG5XZWlnaHQkT3JnYW5XZWlnaHQpXG5wbG90KFNwbG5XZWlnaHRLTyRBZ2UsIFNwbG5XZWlnaHRLTyRPcmdhbldlaWdodClcbnBsb3QoU3BsbldlaWdodFdUJEFnZSwgU3BsbldlaWdodFdUJE9yZ2FuV2VpZ2h0LFxuICAgICB4bGFiID0gJ0FnZSBpbiBEYXlzJyxcbiAgICAgeWxhYiA9ICdXZWlnaHQgaW4gR3JhbXMnLFxuICAgICBtYWluID0gJ1dlaWdodCBvZiBXVCBUaHltdXMnKVxuXG4jcGxvdCB0aGUgY2VsbCBjb3VudHNcbiNcbmBgYCJ9 -->

```r
#Checking out the Spleen and Thymus Weights
ThymWeight = subset(pop, Organ == "Thymus")
SplnWeightKO = subset(pop, Organ == "Spleen" & OrganWeight < 0.79 & Genotype == "KO")
SplnWeightWT = subset(pop, Organ == "Spleen" & OrganWeight < 0.79 & Genotype == "WT")
#There is an outlier in the spleen weight

plot(ThymWeight$Age,ThymWeight$OrganWeight)
plot(SplnWeight$Age, SplnWeight$OrganWeight)
plot(SplnWeightKO$Age, SplnWeightKO$OrganWeight)
plot(SplnWeightWT$Age, SplnWeightWT$OrganWeight,
     xlab = 'Age in Days',
     ylab = 'Weight in Grams',
     main = 'Weight of WT Thymus')

#plot the cell counts
#
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1VzaW5nIEdHcGxvdCB0byBjaGVjayBvdXQgdGhlIHdlaWdodHNcbmdncGxvdChkYXRhPVNwbG5XZWlnaHQsIGFlcyh4PUFnZSwgeT1PcmdhbldlaWdodCkpICtcbiAgZ2VvbV9wb2ludChwb3NpdGlvbiA9IHBvc2l0aW9uX2RvZGdlKHdpZHRoID0gMC44KSwgYWVzKGNvbG9yID0gR2Vub3R5cGUpKVxuICBcbmdncGxvdChkYXRhPVRoeW1XZWlnaHQsIGFlcyh4PUFnZSwgeT1PcmdhbldlaWdodCkpICtcbiAgZ2VvbV9wb2ludChwb3NpdGlvbiA9IHBvc2l0aW9uX2RvZGdlKHdpZHRoID0gMC44KSwgYWVzKGNvbG9yID0gR2Vub3R5cGUpKVxuICBcbmBgYCJ9 -->

```r
#Using GGplot to check out the weights
ggplot(data=SplnWeight, aes(x=Age, y=OrganWeight)) +
  geom_point(position = position_dodge(width = 0.8), aes(color = Genotype))
  
ggplot(data=ThymWeight, aes(x=Age, y=OrganWeight)) +
  geom_point(position = position_dodge(width = 0.8), aes(color = Genotype))
  
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



####################################
#Getting Treg values that did not come from the thymus

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1Bsb3R0aW5nIGFuZCBDb250aW51b3VzbHkgd29ya2luZyB3aXRoIGRhdGFcbiNzb3VyY2UoXCJ+L215LndvcmsvUGhEL0hvbWVzdGF0aWNFeHBhbnNpb25Qcm9qZWN0L0NvZGUvU3RhdHMgcGxvdHMgYW5kIGRhdGEgbWFuYWdlbWVudC9wb3BDb3VudF9WMi5SXCIpXG4jc291cmNlKFwifi9teS53b3JrL1BoRC9Ib21lc3RhdGljRXhwYW5zaW9uUHJvamVjdC9Db2RlL1N0YXRzIHBsb3RzIGFuZCBkYXRhIG1hbmFnZW1lbnQvRnVuY3Rpb25zRGF0YS5SXCIpXG5wb3AgPSByZWFkLmNzdihcIn4vbXkud29yay9QaEQvSG9tZXN0YXRpY0V4cGFuc2lvblByb2plY3QvTW9kZWxEYXRhL0FmdGVyQ2FsY3VsYXRpb25zLmNzdlwiKVxubGlicmFyeShkcGx5cilcbmxpYnJhcnkoXCJSbWlzY1wiKVxubGlicmFyeShcInJlc2hhcGUyXCIpXG4jTmVlZCB0byByZW1vdmUgZGF0ZXMgdGhhdCBhcmUgbm90IHN5bW1ldHJpY2FsIGZvciBzdWJ0cmFjdGlvbnMgLSBEYXRlcyBhcmUgMi8yNS8yMDE4IGFuZCAxMi82LzIwMTdcbiNUaGVyZSBpcyBhIG1pc3NpbmcgdGh5bXVzIGFuZCBvbmx5IG9uZSB0aHltdXMgZm9yIG9uZSBvZiB0aGUgZGF0ZXMgLSBJbmNvbXBsZXRlIGRhdGFcblxucG9wTm9JbmMgPC0gcG9wWyEocG9wJGludGFnZSA9PSAxOCAmIHBvcCRleHBEYXRlPT1cIjIvMjUvMjAxOFwiIHwgcG9wJGV4cERhdGU9PVwiMTIvNi8yMDE3XCIpLF1cbiNkYXkgMCBzY3Jld2luZyB3aXRoIHRoZSBkYXRhXG5wb3BOb0luYyA9IHBvcE5vSW5jWyEocG9wTm9JbmMkQWdlID09IFwiMFwiKSxdXG4jQSBkNTYgc3BsZWVuIGRvZXNuJ3QgaGF2ZSBhIHRoeW11cyBwYXJ0bmVyXG5wb3BOb0luYyA9IHBvcE5vSW5jWyEocG9wTm9JbmMkRmlsZUlEID09IFwiSkEwMjI1MThXSzhNMVdUU1wiKSxdXG4jR3JvdXBpbmcgYW5kIHRoZW4gc3VidHJhY3RpbmcgVGh5bXVzIHRyZWcgZnJlcSBmcm9tIFNwbGVlblxucG9wTm9JbmMgPSBwb3BOb0luYyAlPiVcbiAgIGdyb3VwX2J5KEFnZSwgR2Vub3R5cGUsIGV4cERhdGUpICU+JVxuICAgbXV0YXRlKERpZmYgPSBYNFRyZWdSYXRpbyAtIFg0VHJlZ1JhdGlvW09yZ2FuID09ICdUaHltdXMnXSlcbiNWYWx1ZXMgcmVtb3ZlZCBieSBUaHltdXNcbnBvcE5vSW5jJFg0VHJlZ0Zyb21UaHltdXMgPSBwb3BOb0luYyRYNFRyZWdSYXRpbyAtIHBvcE5vSW5jJERpZmZcbiNSZXBsYWNpbmcgdGhlIE5lZ2F0aXZlIFZhbHVlcyB3aXRoIDBcbnBvcE5vSW5jJERpZmZbcG9wTm9JbmMkRGlmZiA8IDBdIDwtIDBcblxuI3Bsb3R0aW5nIGRpZmZlcmVuY2VzXG5cbiNSZW1vdmluZyB0aGUgc2FtZSB0aGluZ3MgZnJvbSB0aGUgb3JpZ2luYWwgZmlsZSBhcyBJIGRpZCBmb3IgdGhlIHBvcE5vSW5jXG5wb3AyIDwtIHBvcFshKHBvcCRpbnRhZ2UgPT0gMTggJiBwb3AkZXhwRGF0ZT09XCIyLzI1LzIwMThcIiB8IHBvcCRleHBEYXRlPT1cIjEyLzYvMjAxN1wiKSxdXG4jZGF5IDAgc2NyZXdpbmcgd2l0aCB0aGUgZGF0YVxucG9wMiA9IHBvcDJbIShwb3AyJEFnZSA9PSBcIjBcIiksXVxuI0EgZDU2IHNwbGVlbiBkb2Vzbid0IGhhdmUgYSB0aHltdXMgcGFydG5ldFxucG9wMiA9IHBvcDJbIShwb3AyJEZpbGVJRCA9PSBcIkpBMDIyNTE4V0s4TTFXVFNcIiksXVxuXG5wb3AyUyA9IHN1YnNldChwb3AyLCBPcmdhbiA9PSBcIlNwbGVlblwiKVxucG9wTm9JbmNTID0gc3Vic2V0KHBvcE5vSW5jICwgT3JnYW4gPT0gXCJTcGxlZW5cIilcblxuZ2dwbG90KHBvcDJTLCBhZXMoeD1BZ2UsIHk9WDRUcmVnUmF0aW8sIGNvbG91cj1HZW5vdHlwZSwgZ3JvdXA9R2Vub3R5cGUpKSArXG4gIGdlb21fcG9pbnQoc2l6ZT0zKSArXG4gIGxhYnModGl0bGUgPSBcIlRyZWd1bGF0b3J5IENlbGwgRnJlcXVlbmNpZXMgZnJvbSB0aGUgU3BsZWVuXCIsXG4gICAgICAgeSA9IFwiVHJlZyBQZXJjZW50YWdlc1wiKStcbiAgeWxpbSgwLCAwLjE3NSlcblxuIyBUcmVnIHdpdGggZXJyb3IgYmFyc1xuVHJlZ0Vycm9yIDwtIHN1bW1hcnlTRShwb3AyUywgbWVhc3VyZXZhcj1cIlg0VHJlZ1JhdGlvXCIsIGdyb3VwdmFycz1jKFwiQWdlXCIsXCJHZW5vdHlwZVwiKSlcbiNSZXBsYWNpbmcgdGhlIE5BJ3MgcHJvZHVjZWQgYnkgZGF5IDEnc1xuVHJlZ0Vycm9yW2lzLm5hKFRyZWdFcnJvcildID0gMFxuZ2dwbG90KFRyZWdFcnJvciwgYWVzKHg9QWdlLCB5PVg0VHJlZ1JhdGlvLCBjb2xvdXI9R2Vub3R5cGUsIGdyb3VwPUdlbm90eXBlKSkgKyBcbiAgZ2VvbV9lcnJvcmJhcihhZXMoeW1pbj1YNFRyZWdSYXRpby1zZSwgeW1heD1YNFRyZWdSYXRpbytzZSksIGNvbG91cj1cImJsYWNrXCIsIHdpZHRoPS4xLCBwb3NpdGlvbj1wZCkgK1xuICBnZW9tX2xpbmUocG9zaXRpb249cGQpICtcbiAgZ2VvbV9wb2ludChwb3NpdGlvbj1wZCwgc2l6ZT0zKSArXG4gIGxhYnModGl0bGUgPSBcIlRyZWcgUG9wdWxhdGlvbiBQZXJjZW50YWdlIGluIHRoZSBTcGxlZW5cIiwgeSA9IFwiUGVyY2VudFwiLCB4ID0gXCJBZ2UgaW4gRGF5c1wiKStcbiAgdGhlbWUoYXhpcy50ZXh0PWVsZW1lbnRfdGV4dChzaXplPTE0KSxcbiAgICAgICAgYXhpcy50aXRsZT1lbGVtZW50X3RleHQoc2l6ZT0xOCxmYWNlPVwiYm9sZFwiKSxcbiAgICAgICAgcGxvdC50aXRsZSA9IGVsZW1lbnRfdGV4dCggc2l6ZSA9IDE1LCBmYWNlID0gXCJib2xkXCIpXG4gICAgICAgIClcblxuZ2dwbG90KHBvcE5vSW5jUywgYWVzKHg9QWdlLCB5PURpZmYsIGNvbG91cj1HZW5vdHlwZSwgZ3JvdXA9R2Vub3R5cGUpKSArIFxuICBnZW9tX3BvaW50KHNpemU9MykrXG4gIGxhYnModGl0bGUgPSBcIk1pbnVzIHRoZSBUaHltdXMgRnJlcXVlbmNpZXNcIiwgXG4gICAgICAgeSA9IFwiVHJlZyBGcmVxdWVuY3kgTWludXMgVGh5bXVzIEZyZXF1ZW5jeVwiKStcbiAgeWxpbSgwLCAwLjE3NSlcbmdncGxvdChwb3BOb0luY1MsIGFlcyh4PUFnZSwgeT1YNFRyZWdGcm9tVGh5bXVzLCBjb2xvdXI9R2Vub3R5cGUsIGdyb3VwPUdlbm90eXBlKSkgKyBcbiAgZ2VvbV9wb2ludChzaXplPTMpK1xuICBsYWJzKHRpdGxlID0gXCJUcmVnIEZyZXF1ZW5jaWVzIGZyb20gVGh5bXVzXCIsIFxuICAgICAgIHkgPSBcIkZyZXF1ZW5jaWVzIGZyb20gVGh5bXVzXCIpK1xuICB5bGltKDAsIDAuMTc1KVxuXG5gYGAifQ== -->

```r
#Plotting and Continuously working with data
#source("~/my.work/PhD/HomestaticExpansionProject/Code/Stats plots and data management/popCount_V2.R")
#source("~/my.work/PhD/HomestaticExpansionProject/Code/Stats plots and data management/FunctionsData.R")
pop = read.csv("~/my.work/PhD/HomestaticExpansionProject/ModelData/AfterCalculations.csv")
library(dplyr)
library("Rmisc")
library("reshape2")
#Need to remove dates that are not symmetrical for subtractions - Dates are 2/25/2018 and 12/6/2017
#There is a missing thymus and only one thymus for one of the dates - Incomplete data

popNoInc <- pop[!(pop$intage == 18 & pop$expDate=="2/25/2018" | pop$expDate=="12/6/2017"),]
#day 0 screwing with the data
popNoInc = popNoInc[!(popNoInc$Age == "0"),]
#A d56 spleen doesn't have a thymus partner
popNoInc = popNoInc[!(popNoInc$FileID == "JA022518WK8M1WTS"),]
#Grouping and then subtracting Thymus treg freq from Spleen
popNoInc = popNoInc %>%
   group_by(Age, Genotype, expDate) %>%
   mutate(Diff = X4TregRatio - X4TregRatio[Organ == 'Thymus'])
#Values removed by Thymus
popNoInc$X4TregFromThymus = popNoInc$X4TregRatio - popNoInc$Diff
#Replacing the Negative Values with 0
popNoInc$Diff[popNoInc$Diff < 0] <- 0

#plotting differences

#Removing the same things from the original file as I did for the popNoInc
pop2 <- pop[!(pop$intage == 18 & pop$expDate=="2/25/2018" | pop$expDate=="12/6/2017"),]
#day 0 screwing with the data
pop2 = pop2[!(pop2$Age == "0"),]
#A d56 spleen doesn't have a thymus partnet
pop2 = pop2[!(pop2$FileID == "JA022518WK8M1WTS"),]

pop2S = subset(pop2, Organ == "Spleen")
popNoIncS = subset(popNoInc , Organ == "Spleen")

ggplot(pop2S, aes(x=Age, y=X4TregRatio, colour=Genotype, group=Genotype)) +
  geom_point(size=3) +
  labs(title = "Tregulatory Cell Frequencies from the Spleen",
       y = "Treg Percentages")+
  ylim(0, 0.175)

# Treg with error bars
TregError <- summarySE(pop2S, measurevar="X4TregRatio", groupvars=c("Age","Genotype"))
#Replacing the NA's produced by day 1's
TregError[is.na(TregError)] = 0
ggplot(TregError, aes(x=Age, y=X4TregRatio, colour=Genotype, group=Genotype)) + 
  geom_errorbar(aes(ymin=X4TregRatio-se, ymax=X4TregRatio+se), colour="black", width=.1, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  labs(title = "Treg Population Percentage in the Spleen", y = "Percent", x = "Age in Days")+
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"),
        plot.title = element_text( size = 15, face = "bold")
        )

ggplot(popNoIncS, aes(x=Age, y=Diff, colour=Genotype, group=Genotype)) + 
  geom_point(size=3)+
  labs(title = "Minus the Thymus Frequencies", 
       y = "Treg Frequency Minus Thymus Frequency")+
  ylim(0, 0.175)
ggplot(popNoIncS, aes(x=Age, y=X4TregFromThymus, colour=Genotype, group=Genotype)) + 
  geom_point(size=3)+
  labs(title = "Treg Frequencies from Thymus", 
       y = "Frequencies from Thymus")+
  ylim(0, 0.175)

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


#Prepping Thymus data for matlab

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxucG9wVGh5bVdUID0gc3Vic2V0KHBvcFRoeW0sIEdlbm90eXBlID09IFwiV1RcIilcbnBvcFRoeW1XVF9EYXRhRm9yTWF0bGFiID0gZGF0YS5mcmFtZShwb3BUaHltV1QkQWdlLCBwb3BUaHltV1QkT3JnYW5XZWlnaHQpXG5wb3BUaHltV1RfRGF0YUZvck1hdGxhYiA9IG5hLm9taXQocG9wVGh5bVdUX0RhdGFGb3JNYXRsYWIpXG53cml0ZS5jc3YocG9wVGh5bVdUX0RhdGFGb3JNYXRsYWIsICd+L215LndvcmsvUGhEL0hvbWVzdGF0aWNFeHBhbnNpb25Qcm9qZWN0L0NvZGUvTW9kZWxpbmcvTWF0bGFiL0ZpdHRpbmcvVjIvVGh5bXVzRGF0YS5jc3YnKVxuYGBgIn0= -->

```r
popThymWT = subset(popThym, Genotype == "WT")
popThymWT_DataForMatlab = data.frame(popThymWT$Age, popThymWT$OrganWeight)
popThymWT_DataForMatlab = na.omit(popThymWT_DataForMatlab)
write.csv(popThymWT_DataForMatlab, '~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/Fitting/V2/ThymusData.csv')
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->


#Comparing regression of two different trend lines


<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG4jXG4jUmVsZXZhbnQgaW5mb3JtYXRpb246XG4jUEFQRVJTXG4jUGFwZXJzIHRoYXQgZ28gb3ZlciBob3cgdG8gY2hvb3NlIHRoZSByaWdodCBtZXRob2RzXG4jICAgICAxLSBQYXRlcm5vc3RlciwgUi4sIEJyYW1lLCBSLiwgTWF6ZXJvbGxlLCBQLiwgJiBQaXF1ZXJvLCBBLiBSLiAoMTk5OCkuIFVzaW5nIHRoZSBDb3JyZWN0IFN0YXRpc3RpY2FsIFRlc3QgZm9yIHRoZSBFcXVhbGl0eSBvZiBSZWdyZXNzaW9uIENvZWZmaWNpZW50cy4gQ3JpbWlub2xvZ3ksIDM2KDQpLCA4NTnigJM4NjYuXG4jICAgICAyLSBBbmRyYWRlLCBKLiBNLiwgYW5kIE0uIEcuIEVzdMOpdmV6LVDDqXJlei4gXCJTdGF0aXN0aWNhbCBjb21wYXJpc29uIG9mIHRoZSBzbG9wZXMgb2YgdHdvIHJlZ3Jlc3Npb24gbGluZXM6IEEgdHV0b3JpYWwuXCIgQW5hbHl0aWNhIGNoaW1pY2EgYWN0YSA4MzggKDIwMTQpOiAxLTEyLlxuI1xuI0xJTksgVE8gQkVTVCBIRUxQXG4jaHR0cHM6Ly9zdGF0cy5zdGFja2V4Y2hhbmdlLmNvbS9xdWVzdGlvbnMvNTU1MDEvdGVzdC1hLXNpZ25pZmljYW50LWRpZmZlcmVuY2UtYmV0d2Vlbi10d28tc2xvcGUtdmFsdWVzXG5cbiMgTGluayB0aGF0IGdvZXMgb3ZlciB0aGUgZGlmZmVyZW50IHdheXMgdG8gbWFrZSBzdXJlIHlvdXIgY2FsY3VsYXRpb25zIGFyZSByaWdodFxuIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjXG5cbmBgYCJ9 -->

```r
####################################
#
#Relevant information:
#PAPERS
#Papers that go over how to choose the right methods
#     1- Paternoster, R., Brame, R., Mazerolle, P., & Piquero, A. R. (1998). Using the Correct Statistical Test for the Equality of Regression Coefficients. Criminology, 36(4), 859–866.
#     2- Andrade, J. M., and M. G. Estévez-Pérez. "Statistical comparison of the slopes of two regression lines: A tutorial." Analytica chimica acta 838 (2014): 1-12.
#
#LINK TO BEST HELP
#https://stats.stackexchange.com/questions/55501/test-a-significant-difference-between-two-slope-values

# Link that goes over the different ways to make sure your calculations are right
####################################

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuXG4jQWN0dWFsbHkgY2FsY3VsYXRpbmcgdGhlIHJlZ3Jlc3Npb24gbGluZXMgYW5kIGdldHRpbmcgcCB2YWx1ZXNcbnBvcCA9IHJlYWQuY3N2KFwifi9teS53b3JrL1BoRC9Ib21lc3RhdGljRXhwYW5zaW9uUHJvamVjdC9Nb2RlbERhdGEvQWZ0ZXJDYWxjdWxhdGlvbnMuY3N2XCIpXG4jU3Vic2V0dGluZyBXVCBhbmQgS08gLSBSZW1vdmluZyB0aGUgb25lcyBvbGRlciB0aGFuIDU2IGJlY2F1c2UgdGhvc2Ugd2UgYXJlIG5vdCBjb25zaWRlcmluZ1xucG9wV1QgPSBzdWJzZXQocG9wLCBHZW5vdHlwZSA9PSBcIldUXCIgJiBpbnRhZ2UgPCA1NilcbnBvcEtPID0gc3Vic2V0KHBvcCwgR2Vub3R5cGUgPT0gXCJLT1wiKVxuI0luZGVwZW5kZW50IHZhcmlhYmxlIGlzIGFnZSwgYW5kIHdlIGFyZSB0cnlpbmcgdG8gcHJlZGljdCBDRDRDVCAoZGVwZW5kZW50KVxucmVnV1QgPSBsbShmb3JtdWxhID0gQ0Q0Q1QgfiBpbnRhZ2UsIGRhdGEgPSBwb3BXVClcbnJlZ0tPID0gbG0oZm9ybXVsYSA9IENENENUIH4gaW50YWdlLCBkYXRhID0gcG9wS08pXG5zdW1tYXJ5KHJlZ1dUKVxuI0NENENUIH4gaW50YWdlIC0gMC4zMjg3NSwgMC4wNjk5MVxuc3VtbWFyeShyZWdLTylcbiNDRDRDVCB+IGludGFnZSAtIDAuMzk3NDksIDAuMDc0NDVcbiNDYWxjdWxhdGluZyBaIHNjb3JlIChzbDEgLSBzbDIpL3NxcnQoU0UxKioyICsgU0UyKioyKVxuKDAuMzI4NzUgLSAwLjM5NzQ5KSAvIHNxcnQoMC4wNjk5MSoqMiArIDAuMDc0NDUqKjIpXG4jWiA9IC0wLjY3MzA3NDNcbiNwLXZhbHVlIC0gMC4yNTA0NzRcbmBgYCJ9 -->

```r

#Actually calculating the regression lines and getting p values
pop = read.csv("~/my.work/PhD/HomestaticExpansionProject/ModelData/AfterCalculations.csv")
#Subsetting WT and KO - Removing the ones older than 56 because those we are not considering
popWT = subset(pop, Genotype == "WT" & intage < 56)
popKO = subset(pop, Genotype == "KO")
#Independent variable is age, and we are trying to predict CD4CT (dependent)
regWT = lm(formula = CD4CT ~ intage, data = popWT)
regKO = lm(formula = CD4CT ~ intage, data = popKO)
summary(regWT)
#CD4CT ~ intage - 0.32875, 0.06991
summary(regKO)
#CD4CT ~ intage - 0.39749, 0.07445
#Calculating Z score (sl1 - sl2)/sqrt(SE1**2 + SE2**2)
(0.32875 - 0.39749) / sqrt(0.06991**2 + 0.07445**2)
#Z = -0.6730743
#p-value - 0.250474
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1Zpc3VhbGl6aW5nIHRoZSB0cmVuZCBsaW5lc1xuZ2dwbG90KHBvcFdULCBhZXMoeD1pbnRhZ2UsIHk9Q0Q0Q1QpKSArXG4gIGdlb21fcG9pbnQoc2hhcGU9MSkgKyAgICAjIFVzZSBob2xsb3cgY2lyY2xlc1xuICBnZW9tX3Ntb290aChtZXRob2Q9bG0pICsgICMgQWRkIGxpbmVhciByZWdyZXNzaW9uIGxpbmVcbiAgbGFicyh0aXRsZSA9IFwiV2lsZCBUeXBlIENENCBjb3VudHMsIHNsb3BlID0gMC44NzIyXCIpICMoYnkgZGVmYXVsdCBpbmNsdWRlcyA5NSUgY29uZmlkZW5jZSByZWdpb24pXG5nZ3Bsb3QocG9wS08sIGFlcyh4PWludGFnZSwgeT1DRDRDVCkpICtcbiAgZ2VvbV9wb2ludChzaGFwZT0xKSArICAgICMgVXNlIGhvbGxvdyBjaXJjbGVzXG4gIGdlb21fc21vb3RoKG1ldGhvZD1sbSkrICAgIyBBZGQgbGluZWFyIHJlZ3Jlc3Npb24gbGluZSBcbiAgbGFicyh0aXRsZSA9IFwiS25vY2sgT3V0IENENCBjb3VudHMsIHNsb3BlID0gMC44NTg3XCIpICAjICAoYnkgZGVmYXVsdCBpbmNsdWRlcyA5NSUgY29uZmlkZW5jZSByZWdpb24pXG5cbmBgYCJ9 -->

```r
#Visualizing the trend lines
ggplot(popWT, aes(x=intage, y=CD4CT)) +
  geom_point(shape=1) +    # Use hollow circles
  geom_smooth(method=lm) +  # Add linear regression line
  labs(title = "Wild Type CD4 counts, slope = 0.8722") #(by default includes 95% confidence region)
ggplot(popKO, aes(x=intage, y=CD4CT)) +
  geom_point(shape=1) +    # Use hollow circles
  geom_smooth(method=lm)+   # Add linear regression line 
  labs(title = "Knock Out CD4 counts, slope = 0.8587")  #  (by default includes 95% confidence region)

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI1RyZW5kIGxpbmVzIG9mIHRoZSBDRDQgZnJlcXVlbmNpZXNcblxucmVncldUID0gbG0oZm9ybXVsYSA9IENENFJhdGlvIH4gaW50YWdlLCBkYXRhID0gcG9wV1QpXG5yZWdyS08gPSBsbShmb3JtdWxhID0gQ0Q0UmF0aW8gfiBpbnRhZ2UsIGRhdGEgPSBwb3BLTylcbnN1bW1hcnkocmVncldUKVxuc3VtbWFyeShyZWdyS08pXG5gYGAifQ== -->

```r
#Trend lines of the CD4 frequencies

regrWT = lm(formula = CD4Ratio ~ intage, data = popWT)
regrKO = lm(formula = CD4Ratio ~ intage, data = popKO)
summary(regrWT)
summary(regrKO)
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->




<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI3Zpc3VhbGl6aW5nIHRyZW5kIGxpbmVzIG9mIGZyZXF1ZW5jaWVzXG5nZ3Bsb3QocG9wV1QsIGFlcyh4PWludGFnZSwgeT1DRDRSYXRpbykpICtcbiAgZ2VvbV9wb2ludChzaGFwZT0xKSArICAgICMgVXNlIGhvbGxvdyBjaXJjbGVzXG4gIGdlb21fc21vb3RoKG1ldGhvZD1sbSkgKyAgIyBBZGQgbGluZWFyIHJlZ3Jlc3Npb24gbGluZVxuICBsYWJzKHRpdGxlID0gXCJXaWxkIFR5cGUgQ0Q0IGNvdW50cywgc2xvcGUgPSBcIikgIyhieSBkZWZhdWx0IGluY2x1ZGVzIDk1JSBjb25maWRlbmNlIHJlZ2lvbilcbmdncGxvdChwb3BLTywgYWVzKHg9aW50YWdlLCB5PUNENFJhdGlvKSkgK1xuICBnZW9tX3BvaW50KHNoYXBlPTEpICsgICAgIyBVc2UgaG9sbG93IGNpcmNsZXNcbiAgZ2VvbV9zbW9vdGgobWV0aG9kPWxtKSsgICAjIEFkZCBsaW5lYXIgcmVncmVzc2lvbiBsaW5lIFxuICBsYWJzKHRpdGxlID0gXCJLbm9jayBPdXQgQ0Q0IGNvdW50cywgc2xvcGUgPSBcIikgICMgIChieSBkZWZhdWx0IGluY2x1ZGVzIDk1JSBjb25maWRlbmNlIHJlZ2lvbilcbmBgYCJ9 -->

```r
#visualizing trend lines of frequencies
ggplot(popWT, aes(x=intage, y=CD4Ratio)) +
  geom_point(shape=1) +    # Use hollow circles
  geom_smooth(method=lm) +  # Add linear regression line
  labs(title = "Wild Type CD4 counts, slope = ") #(by default includes 95% confidence region)
ggplot(popKO, aes(x=intage, y=CD4Ratio)) +
  geom_point(shape=1) +    # Use hollow circles
  geom_smooth(method=lm)+   # Add linear regression line 
  labs(title = "Knock Out CD4 counts, slope = ")  #  (by default includes 95% confidence region)
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->




<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxucG9wU3BsbiA9IHN1YnNldChwb3AsIE9yZ2FuID09IFwiU3BsZWVuXCIpXG5wZCA8LSBwb3NpdGlvbl9kb2RnZSgwLjEpXG5nZ3Bsb3QocG9wU3BsbiwgYWVzKHg9QWdlLCB5PVRvdGFsTGl2ZUNvdW50SW5NaWxsaW9ucywgY29sb3VyPUdlbm90eXBlLCBncm91cD1HZW5vdHlwZSkpICsgXG4gIGdlb21fcG9pbnQocG9zaXRpb249cGQsIHNpemU9MykgK1xuICBsYWJzKHRpdGxlID0gXCJUb3RhbCBDRDQgVCBDZWxsIENvdW50cyBpbiB0aGUgMTBeNlwiLCB5ID0gXCJDb3VudHNcIiwgeCA9IFwiQWdlIGluIERheXNcIilcblxuI2dldCB0b3RhbCBzcGxlbmljIGNlbGwgY291bnRzIGZvciBXVCBhbmQgS08gdXAgdG8gNCBlYWNoIGZyb20gR2VuZXZpZXZlIGFuZCBLcmlzdGVuLlxuYGBgIn0= -->

```r
popSpln = subset(pop, Organ == "Spleen")
pd <- position_dodge(0.1)
ggplot(popSpln, aes(x=Age, y=TotalLiveCountInMillions, colour=Genotype, group=Genotype)) + 
  geom_point(position=pd, size=3) +
  labs(title = "Total CD4 T Cell Counts in the 10^6", y = "Counts", x = "Age in Days")

#get total splenic cell counts for WT and KO up to 4 each from Genevieve and Kristen.
```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->






#Plotting Spleen CD4,CD8 cells all ages, pre 12

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI0d1aWRlIEkgYW0gdXNpbmcgLSBodHRwOi8vd3d3LmNvb2tib29rLXIuY29tL0dyYXBocy9QbG90dGluZ19tZWFuc19hbmRfZXJyb3JfYmFyc18oZ2dwbG90MikvXG4jTm93IHRvIGdldCB0aGUgZXJyb3IgYmFyc1xuc291cmNlKFwifi9teS53b3JrL1BoRC9Ib21lc3RhdGljRXhwYW5zaW9uUHJvamVjdC9Db2RlL1N0YXRzIHBsb3RzIGFuZCBkYXRhIG1hbmFnZW1lbnQvcG9wQ291bnRfVjIuUlwiKVxubGlicmFyeShcIlJtaXNjXCIpXG5TcGxlZW5Pbmx5ID0gc3Vic2V0KHBvcCwgT3JnYW4gPT0gXCJTcGxlZW5cIilcblxuIyMjIENENFxuXG5DRDRjdCA8LSBzdW1tYXJ5U0UoU3BsZWVuT25seSwgbWVhc3VyZXZhcj1cIkNENENUXCIsIGdyb3VwdmFycz1jKFwiQWdlXCIsXCJHZW5vdHlwZVwiKSlcbnBkIDwtIHBvc2l0aW9uX2RvZGdlKDAuMSlcbmdncGxvdChDRDRjdCwgYWVzKHg9QWdlLCB5PUNENENULCBjb2xvdXI9R2Vub3R5cGUsIGdyb3VwPUdlbm90eXBlKSkgKyBcbiAgI2dlb21fZXJyb3JiYXIoYWVzKHltaW49Q0Q0Q1Qtc2UsIHltYXg9Q0Q0Q1Qrc2UpLCBjb2xvdXI9XCJibGFja1wiLCB3aWR0aD0uMSwgcG9zaXRpb249cGQpICtcbiAgZ2VvbV9saW5lKHBvc2l0aW9uPXBkKSArXG4gIGdlb21fcG9pbnQocG9zaXRpb249cGQsIHNpemU9MykgK1xuICBsYWJzKHRpdGxlID0gXCJUb3RhbCBDRDQgVCBDZWxscyAoMTBeNilcIiwgeSA9IFwiQ291bnRzXCIsIHggPSBcIkFnZSBpbiBEYXlzXCIpICsgXG4gIHRoZW1lKGF4aXMudGV4dD1lbGVtZW50X3RleHQoc2l6ZT0xNCksXG4gICAgICAgIGF4aXMudGl0bGU9ZWxlbWVudF90ZXh0KHNpemU9MTgsZmFjZT1cImJvbGRcIiksXG4gICAgICAgIHBsb3QudGl0bGUgPSBlbGVtZW50X3RleHQoIHNpemUgPSAyMCwgZmFjZSA9IFwiYm9sZFwiKSlcblxuXG5cbiMjIyBDRDhcblxuQ0Q4Y3QgPC0gc3VtbWFyeVNFKFNwbGVlbk9ubHksIG1lYXN1cmV2YXI9XCJDRDhjdFwiLCBncm91cHZhcnM9YyhcIkFnZVwiLFwiR2Vub3R5cGVcIikpXG5cbmdncGxvdChDRDhjdCwgYWVzKHg9QWdlLCB5PUNEOGN0LCBjb2xvdXI9R2Vub3R5cGUsIGdyb3VwPUdlbm90eXBlKSkgKyBcbiAgZ2VvbV9lcnJvcmJhcihhZXMoeW1pbj1DRDhjdC1zZSwgeW1heD1DRDhjdCtzZSksIGNvbG91cj1cImJsYWNrXCIsIHdpZHRoPS4xLCBwb3NpdGlvbj1wZCkgK1xuICBnZW9tX2xpbmUocG9zaXRpb249cGQpICtcbiAgZ2VvbV9wb2ludChwb3NpdGlvbj1wZCwgc2l6ZT0zKSArXG4gIGxhYnModGl0bGUgPSBcIlRvdGFsIENEOCBUIENlbGxzIGluIHRoZSAxMF42IHdpdGggU0UgYmFyc1wiLCB5ID0gXCJDb3VudHNcIiwgeCA9IFwiQWdlIGluIERheXNcIikgKyBcbiAgdGhlbWUoYXhpcy50ZXh0PWVsZW1lbnRfdGV4dChzaXplPTE0KSxcbiAgICAgICAgYXhpcy50aXRsZT1lbGVtZW50X3RleHQoc2l6ZT0xOCxmYWNlPVwiYm9sZFwiKSxcbiAgICAgICAgcGxvdC50aXRsZSA9IGVsZW1lbnRfdGV4dCggc2l6ZSA9IDIwLCBmYWNlID0gXCJib2xkXCIpKVxuXG5cblxuXG4jIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuI1xuIyAgIFByZS05XG4jXG4jIyMjIyMjIyMjIyMjIyMjIyMjIyMjI1xuXG5TcGxlZW5QcmUxMiA8LSBzdWJzZXQoU3BsZWVuT25seSwgaW50YWdlIDwgMTIpXG5cbiMjIyBDRDRcblxuXG5DRDRjdHByZTEyIDwtIHN1bW1hcnlTRShTcGxlZW5QcmUxMiwgbWVhc3VyZXZhcj1cIkNENENUXCIsIGdyb3VwdmFycz1jKFwiQWdlXCIsXCJHZW5vdHlwZVwiKSlcbmdncGxvdChDRDRjdHByZTEyLCBhZXMoeD1BZ2UsIHk9Q0Q0Q1QsIGNvbG91cj1HZW5vdHlwZSwgZ3JvdXA9R2Vub3R5cGUpKSArIFxuICBnZW9tX2Vycm9yYmFyKGFlcyh5bWluPUNENENULXNlLCB5bWF4PUNENENUK3NlKSwgY29sb3VyPVwiYmxhY2tcIiwgd2lkdGg9LjEsIHBvc2l0aW9uPXBkKSArXG4gIGdlb21fbGluZShwb3NpdGlvbj1wZCkgK1xuICBnZW9tX3BvaW50KHBvc2l0aW9uPXBkLCBzaXplPTMpICtcbiAgbGFicyh0aXRsZSA9IFwiVG90YWwgQ0Q0IFQgQ2VsbHMgaW4gdGhlIDEwXjYgd2l0aCBTRSBiYXJzXCIsIHkgPSBcIkNvdW50c1wiLCB4ID0gXCJBZ2UgaW4gRGF5c1wiKSArIFxuICB0aGVtZShheGlzLnRleHQ9ZWxlbWVudF90ZXh0KHNpemU9MTQpLFxuICAgICAgICBheGlzLnRpdGxlPWVsZW1lbnRfdGV4dChzaXplPTE4LGZhY2U9XCJib2xkXCIpLFxuICAgICAgICBwbG90LnRpdGxlID0gZWxlbWVudF90ZXh0KCBzaXplID0gMjAsIGZhY2UgPSBcImJvbGRcIikpXG5cbiMjIyBDRDhcblxuQ0Q4Y3RwcmUxMiA8LSBzdW1tYXJ5U0UoU3BsZWVuUHJlMTIsIG1lYXN1cmV2YXI9XCJDRDhjdFwiLCBncm91cHZhcnM9YyhcIkFnZVwiLFwiR2Vub3R5cGVcIikpXG5nZ3Bsb3QoQ0Q4Y3RwcmUxMiwgYWVzKHg9QWdlLCB5PUNEOGN0LCBjb2xvdXI9R2Vub3R5cGUsIGdyb3VwPUdlbm90eXBlKSkgKyBcbiAgZ2VvbV9lcnJvcmJhcihhZXMoeW1pbj1DRDhjdC1zZSwgeW1heD1DRDhjdCtzZSksIGNvbG91cj1cImJsYWNrXCIsIHdpZHRoPS4xLCBwb3NpdGlvbj1wZCkgK1xuICBnZW9tX2xpbmUocG9zaXRpb249cGQpICtcbiAgZ2VvbV9wb2ludChwb3NpdGlvbj1wZCwgc2l6ZT0zKSArXG4gIGxhYnModGl0bGUgPSBcIlRvdGFsIENEOCBUIENlbGxzIGluIHRoZSAxMF42IHdpdGggU0UgYmFyc1wiLCB5ID0gXCJDb3VudHNcIiwgeCA9IFwiQWdlIGluIERheXNcIikgKyBcbiAgdGhlbWUoYXhpcy50ZXh0PWVsZW1lbnRfdGV4dChzaXplPTE0KSxcbiAgICAgICAgYXhpcy50aXRsZT1lbGVtZW50X3RleHQoc2l6ZT0xOCxmYWNlPVwiYm9sZFwiKSxcbiAgICAgICAgcGxvdC50aXRsZSA9IGVsZW1lbnRfdGV4dCggc2l6ZSA9IDIwLCBmYWNlID0gXCJib2xkXCIpKVxuXG5gYGAifQ== -->

```r
#Guide I am using - http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/
#Now to get the error bars
source("~/my.work/PhD/HomestaticExpansionProject/Code/Stats plots and data management/popCount_V2.R")
library("Rmisc")
SpleenOnly = subset(pop, Organ == "Spleen")

### CD4

CD4ct <- summarySE(SpleenOnly, measurevar="CD4CT", groupvars=c("Age","Genotype"))
pd <- position_dodge(0.1)
ggplot(CD4ct, aes(x=Age, y=CD4CT, colour=Genotype, group=Genotype)) + 
  #geom_errorbar(aes(ymin=CD4CT-se, ymax=CD4CT+se), colour="black", width=.1, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  labs(title = "Total CD4 T Cells (10^6)", y = "Counts", x = "Age in Days") + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"),
        plot.title = element_text( size = 20, face = "bold"))



### CD8

CD8ct <- summarySE(SpleenOnly, measurevar="CD8ct", groupvars=c("Age","Genotype"))

ggplot(CD8ct, aes(x=Age, y=CD8ct, colour=Genotype, group=Genotype)) + 
  geom_errorbar(aes(ymin=CD8ct-se, ymax=CD8ct+se), colour="black", width=.1, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  labs(title = "Total CD8 T Cells in the 10^6 with SE bars", y = "Counts", x = "Age in Days") + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"),
        plot.title = element_text( size = 20, face = "bold"))




#######################
#
#   Pre-9
#
#######################

SpleenPre12 <- subset(SpleenOnly, intage < 12)

### CD4


CD4ctpre12 <- summarySE(SpleenPre12, measurevar="CD4CT", groupvars=c("Age","Genotype"))
ggplot(CD4ctpre12, aes(x=Age, y=CD4CT, colour=Genotype, group=Genotype)) + 
  geom_errorbar(aes(ymin=CD4CT-se, ymax=CD4CT+se), colour="black", width=.1, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  labs(title = "Total CD4 T Cells in the 10^6 with SE bars", y = "Counts", x = "Age in Days") + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"),
        plot.title = element_text( size = 20, face = "bold"))

### CD8

CD8ctpre12 <- summarySE(SpleenPre12, measurevar="CD8ct", groupvars=c("Age","Genotype"))
ggplot(CD8ctpre12, aes(x=Age, y=CD8ct, colour=Genotype, group=Genotype)) + 
  geom_errorbar(aes(ymin=CD8ct-se, ymax=CD8ct+se), colour="black", width=.1, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  labs(title = "Total CD8 T Cells in the 10^6 with SE bars", y = "Counts", x = "Age in Days") + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"),
        plot.title = element_text( size = 20, face = "bold"))

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->












#Plotting Thymus CD4,CD8 cells all ages, pre 12, post 9

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuc291cmNlKFwifi9teS53b3JrL1BoRC9Ib21lc3RhdGljRXhwYW5zaW9uUHJvamVjdC9Db2RlL1N0YXRzIHBsb3RzIGFuZCBkYXRhIG1hbmFnZW1lbnQvcG9wQ291bnRfVjIuUlwiKVxubGlicmFyeShcIlJtaXNjXCIpXG5UaHltdXNPbmx5ID0gc3Vic2V0KHBvcCwgT3JnYW4gPT0gXCJUaHltdXNcIilcblRoeUNENGN0IDwtIHN1bW1hcnlTRShUaHltdXNPbmx5LCBtZWFzdXJldmFyPVwiQ0Q0Q1RcIiwgZ3JvdXB2YXJzPWMoXCJBZ2VcIixcIkdlbm90eXBlXCIpKVxucGQgPC0gcG9zaXRpb25fZG9kZ2UoMC4xKVxuZ2dwbG90KFRoeUNENGN0LCBhZXMoeD1BZ2UsIHk9Q0Q0Q1QsIGNvbG91cj1HZW5vdHlwZSwgZ3JvdXA9R2Vub3R5cGUpKSArIFxuICBnZW9tX2Vycm9yYmFyKGFlcyh5bWluPUNENENULXNlLCB5bWF4PUNENENUK3NlKSwgY29sb3VyPVwiYmxhY2tcIiwgd2lkdGg9LjEsIHBvc2l0aW9uPXBkKSArXG4gIGdlb21fbGluZShwb3NpdGlvbj1wZCkgK1xuICBnZW9tX3BvaW50KHBvc2l0aW9uPXBkLCBzaXplPTMpICtcbiAgbGFicyh0aXRsZSA9IFwiVG90YWwgQ0Q0IFQgQ2VsbHMgKDEwXjYpXCIsIHkgPSBcIkNvdW50c1wiLCB4ID0gXCJBZ2UgaW4gRGF5c1wiKSArIFxuICB0aGVtZShheGlzLnRleHQ9ZWxlbWVudF90ZXh0KHNpemU9MTQpLFxuICAgICAgICBheGlzLnRpdGxlPWVsZW1lbnRfdGV4dChzaXplPTE4LGZhY2U9XCJib2xkXCIpLFxuICAgICAgICBwbG90LnRpdGxlID0gZWxlbWVudF90ZXh0KCBzaXplID0gMjAsIGZhY2UgPSBcImJvbGRcIikpXG5cbiMjIyMjIyMjIyMjXG4jIENEOFxuIyMjIyMjIyMjIyNcblxuVGh5Q0Q4Y3QgPC0gc3VtbWFyeVNFKFRoeW11c09ubHksIG1lYXN1cmV2YXI9XCJDRDhjdFwiLCBncm91cHZhcnM9YyhcIkFnZVwiLFwiR2Vub3R5cGVcIikpXG5wZCA8LSBwb3NpdGlvbl9kb2RnZSgwLjEpXG5nZ3Bsb3QoVGh5Q0Q4Y3QsIGFlcyh4PUFnZSwgeT1DRDhjdCwgY29sb3VyPUdlbm90eXBlLCBncm91cD1HZW5vdHlwZSkpICsgXG4gIGdlb21fZXJyb3JiYXIoYWVzKHltaW49Q0Q4Y3Qtc2UsIHltYXg9Q0Q4Y3Qrc2UpLCBjb2xvdXI9XCJibGFja1wiLCB3aWR0aD0uMSwgcG9zaXRpb249cGQpICtcbiAgZ2VvbV9saW5lKHBvc2l0aW9uPXBkKSArXG4gIGdlb21fcG9pbnQocG9zaXRpb249cGQsIHNpemU9MykgK1xuICBsYWJzKHRpdGxlID0gXCJUb3RhbCBDRDggVCBDZWxscyBpbiB0aGUgMTBeNiB3aXRoIFNFIGJhcnNcIiwgeSA9IFwiQ291bnRzXCIsIHggPSBcIkFnZSBpbiBEYXlzXCIpICsgXG4gIHRoZW1lKGF4aXMudGV4dD1lbGVtZW50X3RleHQoc2l6ZT0xNCksXG4gICAgICAgIGF4aXMudGl0bGU9ZWxlbWVudF90ZXh0KHNpemU9MTgsZmFjZT1cImJvbGRcIiksXG4gICAgICAgIHBsb3QudGl0bGUgPSBlbGVtZW50X3RleHQoIHNpemUgPSAyMCwgZmFjZSA9IFwiYm9sZFwiKSlcblxuYGBgIn0= -->

```r
source("~/my.work/PhD/HomestaticExpansionProject/Code/Stats plots and data management/popCount_V2.R")
library("Rmisc")
ThymusOnly = subset(pop, Organ == "Thymus")
ThyCD4ct <- summarySE(ThymusOnly, measurevar="CD4CT", groupvars=c("Age","Genotype"))
pd <- position_dodge(0.1)
ggplot(ThyCD4ct, aes(x=Age, y=CD4CT, colour=Genotype, group=Genotype)) + 
  geom_errorbar(aes(ymin=CD4CT-se, ymax=CD4CT+se), colour="black", width=.1, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  labs(title = "Total CD4 T Cells (10^6)", y = "Counts", x = "Age in Days") + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"),
        plot.title = element_text( size = 20, face = "bold"))

###########
# CD8
###########

ThyCD8ct <- summarySE(ThymusOnly, measurevar="CD8ct", groupvars=c("Age","Genotype"))
pd <- position_dodge(0.1)
ggplot(ThyCD8ct, aes(x=Age, y=CD8ct, colour=Genotype, group=Genotype)) + 
  geom_errorbar(aes(ymin=CD8ct-se, ymax=CD8ct+se), colour="black", width=.1, position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=3) +
  labs(title = "Total CD8 T Cells in the 10^6 with SE bars", y = "Counts", x = "Age in Days") + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"),
        plot.title = element_text( size = 20, face = "bold"))

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->

#Naive T cell plots

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuRGF0YUZvck1vZGVsID0gcmVhZC5jc3YoXCJ+L215LndvcmsvUGhEL0hvbWVzdGF0aWNFeHBhbnNpb25Qcm9qZWN0L0NvZGUvTW9kZWxpbmcvTWF0bGFiL1Jhd0RhdGEvQWN0aXZhdGVkRGF0YUZvck1vZGVsX1dUU1BMRUVOLmNzdlwiKVxuXG5nZ3Bsb3QoRGF0YUZvck1vZGVsLCBhZXMoeD1BZ2UsIHk9TmFpdmVUX0NlbGxzLCBjb2xvdXI9R2Vub3R5cGUsIGdyb3VwPUdlbm90eXBlKSkgKyBcbiAgZ2VvbV9wb2ludChwb3NpdGlvbj1wZCwgc2l6ZT0zKSArXG4gIGxhYnModGl0bGUgPSBcIlRvdGFsIE5haXZlIFQgQ2VsbCBDb3VudHMgV1RcIiwgeSA9IFwiQ291bnRzXCIsIHggPSBcIkFnZSBpbiBEYXlzXCIpICsgXG4gIHRoZW1lKGF4aXMudGV4dD1lbGVtZW50X3RleHQoc2l6ZT0xNCksXG4gICAgICAgIGF4aXMudGl0bGU9ZWxlbWVudF90ZXh0KHNpemU9MTgsZmFjZT1cImJvbGRcIiksXG4gICAgICAgIHBsb3QudGl0bGUgPSBlbGVtZW50X3RleHQoIHNpemUgPSAyMCwgZmFjZSA9IFwiYm9sZFwiKSlcblxuYGBgIn0= -->

```r
DataForModel = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedDataForModel_WTSPLEEN.csv")

ggplot(DataForModel, aes(x=Age, y=NaiveT_Cells, colour=Genotype, group=Genotype)) + 
  geom_point(position=pd, size=3) +
  labs(title = "Total Naive T Cell Counts WT", y = "Counts", x = "Age in Days") + 
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=18,face="bold"),
        plot.title = element_text( size = 20, face = "bold"))

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->

#Stats for Thymus Weight between WT and IL-2 KO

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxucG9wID0gcmVhZC5jc3YoXCJ+L215LndvcmsvUGhEL0hvbWVzdGF0aWNFeHBhbnNpb25Qcm9qZWN0L01vZGVsRGF0YS9BZnRlckNhbGN1bGF0aW9ucy5jc3ZcIilcbnBvcFRoeW0gPSBzdWJzZXQocG9wLCBPcmdhbiA9PSBcIlRoeW11c1wiKVxucG9wVGh5bTE4V1QgPSBzdWJzZXQocG9wVGh5bSwgaW50YWdlID09IDE4ICYgR2Vub3R5cGUgPT0gXCJXVFwiKVxuIyBwb3BUaHltMThXVCA9IHN1YnNldChwb3BUaHltMThXVCwgT3JnYW5XZWlnaHQgPjUuNSlcbnBvcFRoeW0xOEtPID0gc3Vic2V0KHBvcFRoeW0sIGludGFnZSA9PSAxOCAmIEdlbm90eXBlID09IFwiS09cIilcbnQudGVzdChwb3BUaHltMThXVCRPcmdhbldlaWdodCwgcG9wVGh5bTE4S08kT3JnYW5XZWlnaHQpXG5cbnBvcFRoeW0xOFdUJE9yZ2FuV2VpZ2h0ID0gcG9wVGh5bTE4V1QkT3JnYW5XZWlnaHQgKiAxMDBcbnNkKHBvcFRoeW0xOFdUJE9yZ2FuV2VpZ2h0KVxuXG5wb3BUaHltMThLTyRPcmdhbldlaWdodCA9IHBvcFRoeW0xOEtPJE9yZ2FuV2VpZ2h0ICogMTAwXG5zZChwb3BUaHltMThLTyRPcmdhbldlaWdodClcblxucG9wVGh5bTE0V1QgPSBzdWJzZXQocG9wVGh5bSwgaW50YWdlID09IDE0ICYgR2Vub3R5cGUgPT0gXCJXVFwiKVxucG9wVGh5bTE0S08gPSBzdWJzZXQocG9wVGh5bSwgaW50YWdlID09IDE0ICYgR2Vub3R5cGUgPT0gXCJLT1wiKVxudC50ZXN0KHBvcFRoeW0xNFdUJE9yZ2FuV2VpZ2h0LCBwb3BUaHltMTRLTyRPcmdhbldlaWdodClcbmxlbmd0aChwb3BUaHltMThLTyRPcmdhbldlaWdodClcblxuXG5gYGAifQ== -->

```r
pop = read.csv("~/my.work/PhD/HomestaticExpansionProject/ModelData/AfterCalculations.csv")
popThym = subset(pop, Organ == "Thymus")
popThym18WT = subset(popThym, intage == 18 & Genotype == "WT")
# popThym18WT = subset(popThym18WT, OrganWeight >5.5)
popThym18KO = subset(popThym, intage == 18 & Genotype == "KO")
t.test(popThym18WT$OrganWeight, popThym18KO$OrganWeight)

popThym18WT$OrganWeight = popThym18WT$OrganWeight * 100
sd(popThym18WT$OrganWeight)

popThym18KO$OrganWeight = popThym18KO$OrganWeight * 100
sd(popThym18KO$OrganWeight)

popThym14WT = subset(popThym, intage == 14 & Genotype == "WT")
popThym14KO = subset(popThym, intage == 14 & Genotype == "KO")
t.test(popThym14WT$OrganWeight, popThym14KO$OrganWeight)
length(popThym18KO$OrganWeight)

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



#Stats for Spleen Weight Between WT and IL-2 KO

<!-- rnb-text-end -->


<!-- rnb-chunk-begin -->


<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxucG9wID0gcmVhZC5jc3YoXCJ+L215LndvcmsvUGhEL0hvbWVzdGF0aWNFeHBhbnNpb25Qcm9qZWN0L01vZGVsRGF0YS9BZnRlckNhbGN1bGF0aW9ucy5jc3ZcIilcbnBvcFNwbG4gPSBzdWJzZXQocG9wLCBPcmdhbiA9PSBcIlNwbGVlblwiKVxuXG5wb3AxMlNwbG5XVCA9IHN1YnNldChwb3BTcGxuLCBpbnRhZ2UgPT0gMTIgJiBHZW5vdHlwZSA9PSBcIldUXCIpXG5wb3AxMlNwbG5LTyA9IHN1YnNldChwb3BTcGxuLCBpbnRhZ2UgPT0gMTIgJiBHZW5vdHlwZSA9PSBcIktPXCIpXG50LnRlc3QocG9wMTJTcGxuV1QkT3JnYW5XZWlnaHQscG9wMTJTcGxuS08kT3JnYW5XZWlnaHQgKVxuXG5wb3AxNFNwbG5XVCA9IHN1YnNldChwb3BTcGxuLCBpbnRhZ2UgPT0gMTQgJiBHZW5vdHlwZSA9PSBcIldUXCIpXG5wb3AxNFNwbG5LTyA9IHN1YnNldChwb3BTcGxuLCBpbnRhZ2UgPT0gMTQgJiBHZW5vdHlwZSA9PSBcIktPXCIpXG50LnRlc3QocG9wMTRTcGxuV1QkT3JnYW5XZWlnaHQscG9wMTRTcGxuS08kT3JnYW5XZWlnaHQgKVxuXG5wb3AxOFNwbG5XVCA9IHN1YnNldChwb3BTcGxuLCBpbnRhZ2UgPT0gMTggJiBHZW5vdHlwZSA9PSBcIldUXCIpXG5wb3AxOFNwbG5LTyA9IHN1YnNldChwb3BTcGxuLCBpbnRhZ2UgPT0gMTggJiBHZW5vdHlwZSA9PSBcIktPXCIpXG50LnRlc3QocG9wMThTcGxuV1QkT3JnYW5XZWlnaHQscG9wMThTcGxuS08kT3JnYW5XZWlnaHQgKVxuXG5cbmBgYCJ9 -->

```r
pop = read.csv("~/my.work/PhD/HomestaticExpansionProject/ModelData/AfterCalculations.csv")
popSpln = subset(pop, Organ == "Spleen")

pop12SplnWT = subset(popSpln, intage == 12 & Genotype == "WT")
pop12SplnKO = subset(popSpln, intage == 12 & Genotype == "KO")
t.test(pop12SplnWT$OrganWeight,pop12SplnKO$OrganWeight )

pop14SplnWT = subset(popSpln, intage == 14 & Genotype == "WT")
pop14SplnKO = subset(popSpln, intage == 14 & Genotype == "KO")
t.test(pop14SplnWT$OrganWeight,pop14SplnKO$OrganWeight )

pop18SplnWT = subset(popSpln, intage == 18 & Genotype == "WT")
pop18SplnKO = subset(popSpln, intage == 18 & Genotype == "KO")
t.test(pop18SplnWT$OrganWeight,pop18SplnKO$OrganWeight )

```

<!-- rnb-source-end -->

<!-- rnb-chunk-end -->


<!-- rnb-text-begin -->



<!-- rnb-text-end -->

