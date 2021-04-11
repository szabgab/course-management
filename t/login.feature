#language: en

Feature: Student Login with email
    (More free text about this feture)

    Scenario: Login form has an empty box for email address and a "login" button
        (More text)
    Given a running application
    When we navigate to the student login page
    Then see an empty text box labeled "email"
       And see a button labeled "login"

    @email_available
    Scenario: Student fills in the email address, clicks on the login button
        and receives an email with a one-time code.
    Given a running application
        And we are on the student login page
    When Type in "foo@code-maven.com" in the "email" box
        And click on "login" button.
    Then receive an email with a URL including a code.
