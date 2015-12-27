# My own code for creating the HTML for Google charts.
# Copyright (c) 2015 Defenders of Wildlife, jmalcom@defenders.org

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

library(jsonlite)

'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>BubbleChartID1250b45afe9cc</title>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<style type="text/css">
body {
      color: #444444;
  font-family: Arial,Helvetica,sans-serif;
    font-size: 75%;
    }
  a {
        color: #4D87C7;
    text-decoration: none;
  }
</style>
</head>
<body>'


HEAD <- paste0('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>', chartID, '</title>
<meta http-equiv="content-type" content="text/html;charset=utf-8" />
<style type="text/css">
body {
      color: #444444;
  font-family: Arial,Helvetica,sans-serif;
    font-size: 75%;
    }
  a {
        color: #4D87C7;
    text-decoration: none;
  }
</style>
</head>
<body>')


myGchartBubble <- function(data, idvar="", xvar="", yvar="", colorvar="",
                           sizevar="")















