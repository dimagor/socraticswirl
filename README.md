# Socratic Swirl

Socratic Swirl lets instructors of the R programming language offer in-class, interactive programming exercises, while letting the instructors view student answers and progress in real-time. (For the instructor version, [see here](https://github.com/dimaoo7/socraticswirl-instructor)).

### For students

To install the package, copy and paste the following into your R terminal:

    install.packages("devtools")
    devtools::install_github(c("dgrtwo/rparse", "dimagor/socraticswirl"))


Your instructor will provide your the application key, REST API key and instructor ID. Then, you need to initialize the SocraticSwirl software once in R or RStudio. Suppose you already have the application key, api key and id,
``` r
appkey <- “cut-and-paste your application key”
apikey <- “cut-and-paste your api key”
id <- “your student id”
instructor <- “your instructor’s id”
```

To initialize your copy of SocraticSwirl, please type:
``` r
library(socraticswirl)
socratic_swirl_init(id, appkey, apikey, instructor)
```
You should see "Initialization completed.", which indicate the initialization process succeeded.



Your instructor will also give you a line of code to run within your R terminal, which will register your SocraticSwirl session so that it knows what course and lesson you are taking and who your instructor is. With course_name, lesson_name and your_id you already have, it will look something like this:
``` r
library(socraticswirl)
socratic_swirl(course_name, lesson_name, your_id)
```

After that, you can take any individual exercise, whenever the instructor prompts you, with a single line of R code. To take the first exercise in a lesson, do:

``` r
exercise(1)
```

To take the third exercise, you would do:

``` r
exercise(3)
```

Or, you may take all exercises by:
``` r
start()
```

It's that simple!

### LICENSE

`socraticswirl` is a fork of the [Swirl](https://github.com/swirldev/swirl) package. It is released under the [GPL-3 license](http://www.r-project.org/Licenses/GPL-3).
