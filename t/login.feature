#language: en

Feature: Student Login with email
    (More free text about this feture)

    Scenario: Login form has an empty box for email address and a "login" button
        (More text)
    Given a running application
    When we navigate to the student login page
    Then see an empty text box labeled "email"
       And see a button labeled "login"
