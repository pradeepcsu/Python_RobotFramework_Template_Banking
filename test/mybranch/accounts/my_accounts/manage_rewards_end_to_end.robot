*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../../mybranch_keywords.robot

*** Test Cases ***

Manage Rewards - Rewards Summary Widget Appear - End to End
    [Documentation]    Test to make sure Rewards Summary widget appears.
    ...                On IM2A screen, for checking acc associated with rewards, User Code 1 should be "P" for points, "C" for cash back.
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Open TSSO
    Go To Account Screen    ${checking_account_number}    im2a
    ${user_code_1}=  get field    im2a_userCode1
    Log    ${user_code_1}

    ${manage_rewards} =     exists    Manage Rewards
    Log    ${manage_rewards}
    Run Keyword If    ${manage_rewards} == ${True}    check for manage rewards widget appear

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Summary Widget Doesnt Appear - NegativeTest - End to End
    [Documentation]    Negative Test: Test to make sure Rewards Summary widget doent appear.
    ...                On IM2A screen, for checking acc, User Code 1 should not be "P" for points, "C" for cash back.
    [Tags]    new_test    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Open TSSO
    Go To Account Screen    ${checking_account_number}    im2a
    ${user_code_1}=  get field    im2a_userCode1
    Log    ${user_code_1}

    ${manage_rewards} =     check exists    Manage Rewards
    Log    ${manage_rewards}
    Run Keyword If    ${manage_rewards} == ${False}    check for manage rewards widget doesnt appear

    [Teardown]    Log Out myBranch

