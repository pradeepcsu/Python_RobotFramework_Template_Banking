*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../../mybranch_keywords.robot

*** Test Cases ***
Request Statement Copy - Submit
    [Documentation]    Complete a Statment Copy Request.
    [Tags]    qa_suite    uat2_suite    statements    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_RequestStatementCopy
    Select Aria List Item    RequestStatementCopy_Account    ${account}
    Select Aria List Item    RequestStatementCopy_Month    October
    Select Aria List Item    RequestStatementCopy_Year    2013
    Enter Text    RequestStatementCopy_DeliveryMethod    Test Address
    Click On    Submit
    Expect Text    StatementCopyRequestVerification_Account    ${account}
    Expect Text    StatementCopyRequestVerification_MonthYear    October 2013
    Expect Text    StatementCopyRequestVerification_DeliveryMethod    Test Address
    Click On    StatementCopyRequestVerification_Submit
    Exists    StatementCopyRequestVerification_Success
    [Teardown]    Log Out myBranch

Request Statement Copy - Cancel
    [Documentation]    Cancel a Statment Copy Request.
    [Tags]    qa_suite    statements    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_RequestStatementCopy
    Select Aria List Item    RequestStatementCopy_Account    ${account}
    Select Aria List Item    RequestStatementCopy_Month    February
    Select Aria List Item    RequestStatementCopy_Year    2013
    Enter Text    RequestStatementCopy_DeliveryMethod    Test Address
    Click On    Submit
    Expect Text    StatementCopyRequestVerification_Account    ${account}
    Expect Text    StatementCopyRequestVerification_MonthYear    February 2013
    Expect Text    StatementCopyRequestVerification_DeliveryMethod    Test Address
    Click Link    Cancel
    Exists    RequestStatementCopy_Account
    Click Link    Cancel
    ${list item} =    Get Aria Selected Item    RequestStatementCopy_Account
    Should Be Equal    - Select Account -    ${list item}
    [Teardown]    Log Out myBranch

Request Statement Copy - Edit
    [Documentation]    Edit a Statment Copy Request.
    [Tags]    qa_suite    statements    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_RequestStatementCopy
    Select Aria List Item    RequestStatementCopy_Account    ${account}
    Select Aria List Item    RequestStatementCopy_Month    February
    Select Aria List Item    RequestStatementCopy_Year    2013
    Enter Text    RequestStatementCopy_DeliveryMethod    Test Address
    Click On    Submit
    Expect Text    StatementCopyRequestVerification_Account    ${account}
    Expect Text    StatementCopyRequestVerification_MonthYear    February 2013
    Expect Text    StatementCopyRequestVerification_DeliveryMethod    Test Address
    Click On    StatementCopyRequestVerification_Edit
    Enter Text    RequestStatementCopy_DeliveryMethod    Fixed Address
    Click On    Submit
    Expect Text    StatementCopyRequestVerification_DeliveryMethod    Fixed Address
    Click On    StatementCopyRequestVerification_Submit
    Exists    StatementCopyRequestVerification_Success
    [Teardown]    Log Out myBranch
