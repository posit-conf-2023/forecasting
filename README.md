Tidy time series and forecasting in R
================

### posit::conf 2023

by Rob J Hyndman, Professor of Statistics, Monash University, Australia

-----

INSTRUCTIONS FOR INSTRUCTORS: Please insert information about your
workshop below. Then, add workshop content in the materials folder and
link to each session’s materials from the schedule below. You are
welcomed to add more rows to the schedule. We just ask that you take
breaks at the specified times. Once you are done adding information, you
can remove these instructions from the README.

Alternatively, you can completely redo the organization of this repo 
as a Quarto website or some other format you prefer to host your workshop
materials. The only requirement is that your workshop materials are hosted 
here.

-----

:spiral_calendar: September 17 and 18, 2023  
:alarm_clock:     09:00 - 17:00  
:hotel:           ROOM TBD  
:writing_hand:    [pos.it/conf](http://pos.it/conf)

-----

## Overview

It is common for organizations to collect huge amounts of data over time, and existing time series analysis tools are not always suitable to handle the scale, frequency and structure of the data collected. In this workshop, we will look at some packages and methods that have been developed to handle the analysis of large collections of time series.

On day 1, we will look at the tsibble data structure for flexibly managing collections of related time series. We will look at how to do data wrangling, data visualizations and exploratory data analysis. We will explore feature-based methods to explore time series data in high dimensions. A similar feature-based approach can be used to identify anomalous time series within a collection of time series, or to cluster or classify time series. Primary packages for day 1 will be tsibble, lubridate and feasts (along with the tidyverse of course).

Day 2 will be about forecasting. We will look at some classical time series models and how they are automated in the fable package, and we will explore the creation of ensemble forecasts and hybrid forecasts. Best practices for evaluating forecast accuracy will also be covered. Finally, we will look at forecast reconciliation, allowing millions of time series to be forecast in a relatively short time while accounting for constraints on how the series are related.

**This workshop is for you if you...**

* already use the tidyverse packages in R such as dplyr, tidyr, tibble and ggplot2
* need to analyze large collections of related time series
* would like to learn how to use some tidy tools for time series analysis including visualization, decomposition and forecasting

## Prework

People who don’t use R regularly, or don’t know the tidyverse packages, are recommended to do the tutorials at [learnr.numbat.space](http://learnr.numbat.space) beforehand.

Please bring your own laptop with a recent version of R and RStudio installed. The following code will install the main packages needed for the workshop.

```r
install.packages(c("tidyverse", "fpp3", "GGally", "sugrrants"))
```

## Schedule

### Day 1

| Time          | Activity         |
| :------------ | :--------------- |
| 09:00 - 10:30 | Session 1        |
| 10:30 - 11:00 | *Coffee break*   |
| 11:00 - 12:30 | Session 2        |
| 12:30 - 13:30 | *Lunch break*    |
| 13:30 - 15:00 | Session 3        |
| 15:00 - 15:30 | *Coffee break*   |
| 15:30 - 17:00 | Session 4        |

### Day 2

| Time          | Activity         |
| :------------ | :--------------- |
| 09:00 - 10:30 | Session 1        |
| 10:30 - 11:00 | *Coffee break*   |
| 11:00 - 12:30 | Session 2        |
| 12:30 - 13:30 | *Lunch break*    |
| 13:30 - 15:00 | Session 3        |
| 15:00 - 15:30 | *Coffee break*   |
| 15:30 - 17:00 | Session 4        |

## Instructor

Rob J Hyndman is Professor of Statistics in the Department of Econometrics and Business Statistics at Monash University, Australia. Rob is the author of over 200 research papers, 5 books, and over 50 R packages (most of which are on CRAN). He is an elected Fellow of both the Australian Academy of Science and the Academy of Social Sciences in Australia. In 2007, he received the Moran medal from the Australian Academy of Science for his contributions to statistical research, especially in the area of statistical forecasting. In 2021, he received the Pitman medal from the Statistical Society of Australia. For over 30 years, Rob has maintained an active consulting practice, assisting hundreds of companies and organizations around the world. He has won awards for his research, teaching, consulting and graduate supervision.

-----

![](https://i.creativecommons.org/l/by/4.0/88x31.png) This work is
licensed under a [Creative Commons Attribution 4.0 International
License](https://creativecommons.org/licenses/by/4.0/).
