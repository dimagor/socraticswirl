
# Participant DB
# 
# swirl:::Parse_create()
# 
# udb_dima
# 
# Fields: course, lesson, instructor

# swirl:::Parse_create("pdb_dima",course="default",lesson="ggplot", instructor="dima", )

for(i in seq(10)) swirl:::Parse_create("udb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i))


# AnswerDB 
# 
# adb_dima
# 
# Fields: course, lesson, instructor, student, exercise, correct, answer
for(i in seq(3,7)) swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i), exercise=1, correct=FALSE, answer=paste("attempt1"))
for(i in seq(7,8)) swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i), exercise=1, correct=TRUE, answer=paste("awesome"))
for(i in seq(3,6)) swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i), exercise=1, correct=FALSE, answer=paste("attempt2"))
for(i in seq(5,6)) swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i), exercise=1, correct=TRUE, answer=paste("awesome"))

for(i in seq(1,9)) swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i), exercise=2, correct=FALSE, answer=paste("attempt1"))
for(i in seq(4,8)) swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i), exercise=2, correct=TRUE, answer=paste("awesome"))
for(i in seq(9,10)) swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i), exercise=2, correct=TRUE, answer=paste("awesome"))


for(i in seq(1,4)) swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i), exercise=2, correct=FALSE, answer=paste("whybother"))
for(i in seq(3,4)) swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(i), exercise=2, correct=TRUE, answer=paste("fantastic"))

swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(2), exercise=3, correct=FALSE, answer=paste("ggplot(diamonds)"))
swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(2), exercise=3, correct=FALSE, answer=paste("ggplot(carats)"))
swirl:::Parse_create("adb_dima",course="default",lesson="ggplot", instructor="dima", student=digest(5), exercise=3, correct=FALSE, answer=paste("ggplot is awesome?"))


# Lecture DB
swirl:::Parse_create("lecdb_dima",course="default",lesson="ggplot", instructor="dima", exercise=1, description="Load ggplot library", desired_answer="library(ggplot2)")
swirl:::Parse_create("lecdb_dima",course="default",lesson="ggplot", instructor="dima", exercise=2, description="Count the diamonds db by color", desired_answer="count(diamonds,color)")
swirl:::Parse_create("lecdb_dima",course="default",lesson="ggplot", instructor="dima", exercise=3, description="Plot diamonds: carat vs price", desired_answer="ggplot(diamonds,aes(carat,price))+geom_point()")
swirl:::Parse_create("lecdb_dima",course="default",lesson="ggplot", instructor="dima", exercise=4, description="Plot diamonds: carat vs price with color breakdown", desired_answer="ggplot(diamonds,aes(carat,price,color=color))+geom_point()")


                                        

