#explore currency research data

#Leading Indicators of Currency Crises
#Carmen Reinhart and Graciela Kaminsky and Saul Lizondo
#University of Maryland
#1998

require(gdata)
require(reshape2)
require(rCharts); options(viewer=NULL)

table1 <- read.xls(
  "reinhart_1998.xlsx"
  ,sheet="table1"
  ,header=FALSE
  ,stringsAsFactors=FALSE
)

table1.melt <- melt(melt(table1[-1,]),id.vars=1)

colnames(table1.melt) <- c("indicator","measurenum","value")

table1.melt$measurenum <- as.character(table1.melt$measurenum)
table1.melt$measure <- as.vector(
  t(table1[1,table1.melt$measurenum])
)


d1 <- dPlot(
  x = "value"
  ,y = c("measurenum", "indicator")
  ,groups = c("measure","indicator")
  ,data = table1.melt
  ,type = "bar"
  ,height = 600
  ,width = 1000
)
d1$xAxis( type = "addMeasureAxis" )
d1$yAxis( type = "addCategoryAxis", orderRule = "measurenum" )
d1

#d1$publish (description = "dimple + rCharts on Reinhart (1998)")


#make it parallel coordinates
p1 <- rCharts$new()
p1$setLib(system.file('parcoords', package = 'rCharts'))
p1$templates$script = "./chart_more.html"
p1$set(
  padding = list(top = 24, left = 100, bottom = 12, right = 100),
  height = "400",
  width = "1000",
  color = "d3.scale.category10()"
)

p1$set(
  data = toJSONArray(
    dcast(table1.melt, indicator ~ measurenum
          )
    , json = F
  )
  ,colorby = 'indicator'
)
p1$setTemplate(
  afterScript = '
 <script>
 d3.selectAll("svg").selectAll("text")
 .style("font-size","10px")
 </script>
 '
)
p1
#p1$save("example15.html",cdn=T)
