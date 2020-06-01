*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Keywords ***
    

*** Test Cases ***
Login - Forgot Password
    [Documentation]    Verify Forgot Password page.
    [Tags]    qa_suite    accounts    login
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    load browser
    Maximize Browser Window

    Click On    LogIn_ForgotPassword
    Assert Page Contains    Confirm Your Identity
    Capture Page Screenshot
    Click On    Cancel_SelfService
    Click On    Cancel_ResetPassword
    
Login - User Name Not On File
    [Documentation]    Verify error dialog on incorrect login user name. UFT test: "Invalid Login"
    [Tags]    new_test    login    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Maximize Browser Window
    ${random_username} =    Get Random String    8
    Log    ${random_username}
    Enter Text    LogIn_UserID    ${random_username}
    Enter Text    LogIn_Password    ${password}}
    Click On    LogIn_LogIn
    Assert Page Contains    Your User Name and/or Password does not match the information we have on file. Please try again.
    Capture Page Screenshot

Login - Password Not On File
    [Documentation]    Verify error dialog on incorrect login password. UFT test: "Invalid Login"
    [Tags]    qa_suite    login
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Maximize Browser Window
    ${random_password} =    Get Random String    8
    Log    ${random_password}
    Enter Text    LogIn_UserID    ${username}
    Enter Text    LogIn_Password    ${random_password}}
    Click On    LogIn_LogIn
    Assert Page Contains    Your User Name and/or Password does not match the information we have on file. Please try again.
    Capture Page Screenshot
   
Login - Extend Session
    [Documentation]    Verify Extend Session option.
    [Tags]    qa_suite    login    long_run
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    #Sleep    9 minutes 30 seconds
    Sleep    9 minutes 5 seconds
    Capture Page Screenshot
    Click On    LogOut_ExtendSession
    Assert Page Contains    You are currently logged in.
    [Teardown]    Log Out myBranch
    
Login - Session Expire
    [Documentation]    Verify Session Expires.
    [Tags]    qa_suite    login    long_run
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Sleep    9 minutes 30 seconds
    Capture Page Screenshot
    Sleep    30 seconds
    Assert Page Contains    To start a new session, please log in below.
    [Teardown]    Log Out myBranch

Login - Enroll User Not In System
    [Documentation]    "New Online Banking User - Enroll - User Not In System"
    [Tags]    qa_suite    login
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Maximize Browser Window
    Click On    Enroll_EnrollNow
    Click On    Enroll_TermsCheckBox
    Click On    Enroll_BeginEnrollmentButton
    ${random_accountnumber} =    Get Random Number String    10
    Enter Text    Enroll_PrimarySavings    ${random_accountnumber}    click_first=enroll_test
    Select Aria List Item    Enroll_AccountType    Personal
    Enter Text    Enroll_TIN    520272070
    Enter Text    Enroll_DOB    1/1/1990
    Enter Text    Enroll_Address    123 Main St.
    Enter Text    Enroll_ZIP    78250
    Click On    Enroll_NextButton
    Assert Page Contains    The information provided does not match our records. Please try again or call 1.800.229.0158 for assistance.

Login - Session Logout
    [Documentation]    "myBranch session logout on Inactivity. UFT Test: Mybranch Session LogOut"
    [Tags]    qa_suite    uat2_suite    login    long_run
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Capture Page Screenshot
    Sleep    555
    Click On    LogOut_SessionLogOut
    Capture Page Screenshot

Login - Account Locked
    [Documentation]    Unlocking Locked Accounts
    [Tags]    accounts    login    incomplete
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}

    Log In myBranch    ${username}    ${password}
    ${Error_Message} =     check exists    Account_Locked
    Log    ${Error_Message}
    Run Keyword If    ${Error_Message} == ${True}    Log      ${username} Account is Locked
    Capture Page Screenshot
    Open Browser    https://mybranchadmin-qa.qatssfcu.org    gc
    Maximize Browser Window
    Enter Text    AdminTool_MemberNumber     ${username}
    Click On    AdminTool_Search
	Click On    AdminTool_myBranchTab
	Click On   AdminTool_StatusEditButton
	Select Kendo Dropdown    AdminTool_BankingStatus    Unlocked
    Click On   AdminTool_StatusEditButton
    Assert Page Contains    ACTIVE
    Close Browser
    Click Link    AccountLocked_LoginAgain
    Log In myBranch    ${username}    ${password}
    Assert Page Contains    You are currently logged in.
    [Teardown]    Log Out myBranch