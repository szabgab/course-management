#language: en

Feature: Student Login with email
    (More free text about this feture)

    Background: Some free text
    Given a running application

    Scenario: Login form has an empty box for email address and a "login" button
        (More text)
    When we navigate to the student login page
    Then see an empty text box labeled "email"
       And see a button labeled "login"

    #@email_available @other
    #Scenario: Student fills in the email address, clicks on the login button
    #    and receives an email with a one-time code.
    #Given we are on the student login page
    #When Type in "foo@code-maven.com" in the "email" box
    #    And click on "login" button.
    #Then student sees a page "email was sent"
    #    And receive an email with a URL including a code.

    #@email_available
    #Scenario: Student fills in the email address, clicks on the login button
    #    and receives an email with a one-time code.
    #Given we are on the student login page
    #When Type in "bar@code-maven.com" in the "email" box
    #    And click on "login" button.
    #Then student sees a page "email was incorrect"
    #    And no email was sent.

    #@email_available
    #Scenario: Student fills in the email address, clicks on the login button
    #    and receives an email with a one-time code.
    #Given we are on the student login page
    #When Type in "<email address>" in the "email" box
    #    And click on "login" button.
    #Then student sees a page "<response page>"
    #    And <email action>
    #Examples: (Some free text here)
    #  |   email address    |   response page       | email action                                  |
    #  | foo@code-maven.com |   email was sent      | receive an email with a URL including a code. |
    #  | bar@code-maven.com |   email was incorrect | no email was sent.                            |

