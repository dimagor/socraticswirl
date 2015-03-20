## To Do: Client/Parse side

* Security
  * First: any R client can add Answer objects, but should not be able to change the class, create new classes, or (especially) read Answers
  * Each instructor should have his own user account, and be able to work only with answers from his own quizzes. This means an `instructor` field should be passed to `socratic_swirl`

* Make setup easier
  * Install from multiple sources, not just GitHub.
  * Allow instructors to register their quiz files on the Parse app, which accepts it as a File object and packages it as a .zip for `install_course_url` to install:

      socratic_register("dgrtwo", "mypassword")
      upload_quiz("ggplot2_exercises.yaml", name = "ggplot2_basics", public = TRUE)
      # uploading...
      # done. Students can install and take your quiz with the line:
      #  socratic_swirl("ggplot2_basics", instructor = "dgrtwo")

  * Also a Shiny website that displays all public quizzes

* Error handling
  * Report if there was an error communicating with the Parse server
