*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Keywords ***
    

*** Test Cases ***

Transfers - Add External Checking Account
    [Documentation]    Test adds external checking account to existing myBranch member.
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    [Tags]    qa_suite
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_AddAccount

    Select Radio Option    IsBusinessAccount    False
    Select Radio Option    IsSSFCUAccount    False
    Select Radio Option    IsOwner    True
    Click On    Next

    # Account set-up screen
    Enter Text    External_Account_Firstname    TestFirst
    Enter Text    External_Account_Lastname    TestLast
    Enter Text    External_Account_Nickname    TestNickname
    select kendo dropdown    External_Account_Type    CHECKING
    ${account_number} =    Get Random Number
    Log    ${account_number}
    Enter Aria Text    External_Account_AccountNo    ${account_number}
    Enter Aria Text    External_Account_ReEnterAccountNo    ${account_number}
    Enter Text    External_Account_RoutingNo    111000614
    Click On    External_Account_AcceptTerms_CheckBox

    Click On    Next
    Capture Page Screenshot
    Sleep    3

    # confirmation page
    Assert Page Contains    Please verify the information entered is correct
    Expect Text Contains    External_Account_Verify_Firstname    TestFirst
    Expect Text Contains    External_Account_Verify_Lastname    TestLast
    Expect Text Contains    External_Account_Verify_Nickname    TestNickname
    Expect Text Contains    External_Account_Verify_Type    CHECKING
    Expect Text Contains    External_Account_Verify_AccountNo    ${account_number}
    Expect Text Contains    External_Account_Verify_RoutingNo    111000614

    Click On    Next
    Sleep    3
    Assert Page Contains    Confirmation
    Assert Page Contains    The Transfer/Payment Account has been added, but will not be ready for use until it’s verified.
    Assert Page Contains    Before you can begin sending transfers or payments to and from this account, you must verify it.

    # verify and Unlink the added external account

    Click On    Ribbon_Transfers_Payments
    Click On    Leftnav_Transfers_ManageAccounts

    Click On    Leftnav_Transfers_ManageAccounts
    ${row} =    Get Table Row Count    External_Accounts_Table
    Log    ${row}

    Expect Text Containing In Table Cell    External_Accounts_Table    ${row}    2    TestNickname
    Expect Text In Table Cell    External_Accounts_Table    ${row}    3    CHECKING
    Expect Text Containing In Table Cell    External_Accounts_Table    ${row}    4    TestNickname
    Expect Text In Table Cell    External_Accounts_Table    ${row}    5    New
    Expect Text In Table Cell    External_Accounts_Table    ${row}    6    Unlink

    Click Unlink Account    ${row}
    Click On    UnlinkAccount_Unlink
    Click On    UnlinkAccount_Close

    [Teardown]    Log Out myBranch


Transfers - Add External Savings Account
    [Documentation]    Test adds external Savings account to existing myBranch member.
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    [Tags]    qa_suite
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_AddAccount

    Select Radio Option    IsBusinessAccount    False
    Select Radio Option    IsSSFCUAccount    False
    Select Radio Option    IsOwner    True
    Click On    Next

    # Account set-up screen
    Enter Text    External_Account_Firstname    TestFirst
    Enter Text    External_Account_Lastname    TestLast
    Enter Text    External_Account_Nickname    TestNickname
    select kendo dropdown    External_Account_Type    SAVINGS
    ${account_number} =    Get Random Number
    Log    ${account_number}
    Enter Aria Text    External_Account_AccountNo    ${account_number}
    Enter Aria Text    External_Account_ReEnterAccountNo    ${account_number}
    Enter Text    External_Account_RoutingNo    111000614
    Click On    External_Account_AcceptTerms_CheckBox

    Click On    Next
    Capture Page Screenshot
    Sleep    3

    # confirmation page
    Assert Page Contains    Please verify the information entered is correct
    Expect Text Contains    External_Account_Verify_Firstname    TestFirst
    Expect Text Contains    External_Account_Verify_Lastname    TestLast
    Expect Text Contains    External_Account_Verify_Nickname    TestNickname
    Expect Text Contains    External_Account_Verify_Type    SAVINGS
    Expect Text Contains    External_Account_Verify_AccountNo    ${account_number}
    Expect Text Contains    External_Account_Verify_RoutingNo    111000614

    Click On    Next
    Sleep    3
    Assert Page Contains    Confirmation
    Assert Page Contains    The Transfer/Payment Account has been added, but will not be ready for use until it’s verified.
    Assert Page Contains    Before you can begin sending transfers or payments to and from this account, you must verify it.

    # verify and Unlink the added external account

    Click On    Ribbon_Transfers_Payments
    Click On    Leftnav_Transfers_ManageAccounts

    Click On    Leftnav_Transfers_ManageAccounts
    ${row} =    Get Table Row Count    External_Accounts_Table
    Log    ${row}

    Expect Text Containing In Table Cell    External_Accounts_Table    ${row}    2    TestNickname
    Expect Text In Table Cell    External_Accounts_Table    ${row}    3    SAVINGS
    Expect Text Containing In Table Cell    External_Accounts_Table    ${row}    4    TestNickname
    Expect Text In Table Cell    External_Accounts_Table    ${row}    5    New
    Expect Text In Table Cell    External_Accounts_Table    ${row}    6    Unlink

    Click Unlink Account    ${row}
    Click On    UnlinkAccount_Unlink
    Click On    UnlinkAccount_Close

    [Teardown]    Log Out myBranch


