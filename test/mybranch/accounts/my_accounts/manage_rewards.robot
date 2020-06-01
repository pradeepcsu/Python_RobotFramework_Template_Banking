*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../../mybranch_keywords.robot

*** Test Cases ***

Manage Rewards - Rewards Summary Widget Appear
    [Documentation]    Test to make sure Rewards Summary widget appears.
    [Tags]    new_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    check for manage rewards widget appear

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Summary Widget Doesnt Appear - NegativeTest
    [Documentation]    Negative Test: Test to make sure Rewards Summary widget doesnt appear.
    [Tags]    new_test    negative_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    check for manage rewards widget doesnt appear

    [Teardown]    Log Out myBranch

Manage Rewards - Verify My Rewards Table
    [Documentation]    Test to verify My Rewards table column values.
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    click on    Manage Rewards

    ${row} =    Get Table Row Count    Manage Rewards_RewardsOptions_Table
    Expect Text In Table Cell    Manage Rewards_RewardsOptions_Table    ${row}    1    POWER MERIT CHECKING ***70071
    Expect Text In Table Cell    Manage Rewards_RewardsOptions_Table    ${row}    2    Cash Back
    Expect Text Containing In Table Cell    Manage Rewards_RewardsOptions_Table    ${row}    3    $0.00 Year-to-Date
    Expect Text In Table Cell    Manage Rewards_RewardsOptions_Table    ${row}    4    Learn More
    capture page screenshot

    [Teardown]    Log Out myBranch

Manage Rewards - Verify Rewards program Details - Cash Back
    [Documentation]    Test to verify the cash back link opens existing rewards details modal dialog with cash back tab selected
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    click on    Manage Rewards
    click on    Manage Rewards_Cash Back
    exists    Manage Rewards_Reward_Program_Details_Tab
    click on    Manage Rewards_Reward_Program_Details_Tab_Close

    [Teardown]    Log Out myBranch

Manage Rewards - Verify Rewards program Details - Points
    [Documentation]    Test to verify the points link opens existing rewards details modal dialog with points tab selected
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    click on    Manage Rewards
    click on    Manage Rewards_Points
    exists    Manage Rewards_Reward_Program_Details_Tab
    Assert Page Contains    Rewards Points Program Features
    click on    Manage Rewards_Reward_Program_Details_Tab_Close

    [Teardown]    Log Out myBranch

Manage rewards - Verify learn More URL - Cash Back
    [Documentation]    Test to verify the learn more url which display(on clicking) existing rewards details(cash back)
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    click on    Manage Rewards
    click on    Manage Rewards_Learn More
    exists    Manage Rewards_Reward_Program_Details_Tab
    Assert Page Contains    Rewards Points Program Features
    click on    Manage Rewards_Reward_Program_Details_Tab_Close

    [Teardown]    Log Out myBranch

Manage rewards - Verify Redeem URL
    [Documentation]    Test to verify the redeem url which navigates(on clicking)  to MSR site
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    #click on    Manage Rewards
    click on    Manage Rewards_Redeem_URL
    Sleep    5
    Register Window
    Log Title
    Title Should Be    Rewards Center l Security Service
    Capture Page Screenshot
    Close Window
    Unregister Window

    [Teardown]    Log Out myBranch

Manage Rewards - Verify My Rewards Table - Hidden Account
    [Documentation]    Test to verify My Rewards table with Account Rewards Type, Rewards Earned
    ...    & Information on how to redeem rewards(URL), even if the associated account has been hidden.
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    click on    Manage Rewards

    ${row} =    Get Table Row Count    Manage Rewards_RewardsOptions_Table
    Expect Text In Table Cell    Manage Rewards_RewardsOptions_Table    ${row}    1    POWER PROTECTED MERIT CHECKING ***98071
    Expect Text In Table Cell    Manage Rewards_RewardsOptions_Table    ${row}    2    Cash Back
    Expect Text Containing In Table Cell    Manage Rewards_RewardsOptions_Table    ${row}    3    $0.00 Year-to-Date
    Expect Text In Table Cell    Manage Rewards_RewardsOptions_Table    ${row}    4    Learn More
    capture page screenshot

    [Teardown]    Log Out myBranch

Manage Rewards - Verify Disclaimer - Year-to-Date
    [Documentation]    Test to Verify conditional disclaimer display at the bottom of the page.
    ...    Total cash back(debit cards) disclaimer when Year-to-Date populates in Rewards Earned section.
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}


    [Teardown]    Log Out myBranch

Manage Rewards - Disclaimer - Total Points
    [Documentation]    Test to verify the disclaimer message with Power Rewards Agreement(PDF) - Total Points
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    click on    Manage Rewards
    assert page contains    Points balance is based on the total from the previous business day and may not reflect most recent purchases or redemptions. Power Rewards Agreement (.pdf)
    click on    Manage Rewards_Points_Desclaimer_URL
    Register Window
    location should contain    https://www.ssfcu.org/SiteCollectionDocuments/business-disclosures/consumer-business-rewards-program-tc.pdf
    Capture Page Screenshot
    Close Window
    Unregister Window

    [Teardown]    Log Out myBranch

Manage Rewards - Disclaimer - Credit Cards
    [Documentation]    Test to verify the disclaimer message with Power Rewards Agreement(PDF) - Credit Cards
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    click on    Manage Rewards
    assert page contains    Cash Back balance is based on previous day’s transactions. More recent transaction may not be reflected in the total amount. Not currently available for Business accounts. Power Rewards Agreement (.pdf)
    click on    Manage Rewards_Points_Desclaimer_URL
    Register Window
    location should contain    https://www.ssfcu.org/SiteCollectionDocuments/business-disclosures/consumer-business-rewards-program-tc.pdf
    Capture Page Screenshot
    Close Window
    Unregister Window

    [Teardown]    Log Out myBranch

Manage Rewards - Disclaimer - Debit Cards
   [Documentation]    Test to verify the disclaimer message with Power Rewards Agreement(PDF) - Debit Cards
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    click on    Manage Rewards
    assert page contains    Cash Back balance is based on previous day’s transactions. More recent transaction may not be reflected in the total amount. Not currently available for Business accounts. Power Rewards Agreement (.pdf)
    click on    Manage Rewards_Points_Desclaimer_URL
    Register Window
    location should contain    https://www.ssfcu.org/SiteCollectionDocuments/business-disclosures/consumer-business-rewards-program-tc.pdf
    Capture Page Screenshot
    Close Window
    Unregister Window

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Summary Widget Appear - Points
    [Documentation]    Test to make sure Rewards Summary widget appears when enrolledinpoints = Y
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    check for manage rewards widget appear

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Summary Widget Appear - CashBack
    [Documentation]    Test to make sure Rewards Summary widget appears when enrolledincashback = Y
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    check for manage rewards widget appear

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Summary Widget Appear - HiddenAccount
    [Documentation]    Test to make sure Rewards Summary widget continues to appears even when account is hidden
    [Tags]    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    check for manage rewards widget appear

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Link Appear - HiddenAccount
    [Documentation]    Test to make sure Rewards Summary widget continues to appears even when account is hidden
    [Tags]    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Exists    Manage Rewards

    [Teardown]    Log Out myBranch


Manage Rewards - Rewards Widget Displays Correctly
    [Documentation]    Test to make sure Rewards widget displays correctly (Req 1.2)
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    check for manage rewards widget appear
    Expect Text Contains    Rewards_Details_Link     View Details
    Click On    Rewards_Details_Link
    check if my rewards page is loaded

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Disclaimer Appear - PersonalAccount
    [Documentation]    Test to make sure myBranch will display the disclaimers on the Account Summary Page
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    check personal account rewards disclaimers

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Disclaimer Appear - CommercialAccount
    [Documentation]    Test to make sure myBranch will display the disclaimers on the Account Summary Page
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    check commercial account rewards disclaimers

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Disclaimer Displays Correctly
    [Documentation]    Test to make sure Total Rewards Disclaimer displays correctly
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    check personal account rewards disclaimers

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Points Details Modal Dialog Displays Correctly
    [Documentation]    Test to make sure Rewards Points Details Modal Dialog Displays Correctly
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    RewardsPoints_Disclaimer_Link
    Exists    RewardsPointsDetails_Table
    Assert Page Contains    Rewards Program Details
    Assert Page Contains    Rewards Points
    Click On    RewardsPointsDetails_Table_Close

    [Teardown]    Log Out myBranch

Manage Rewards - Total Cash Back Disclaimer for Credit Card
    [Documentation]    Test to Verify the Total Cash Back disclaimer shows correctly for credit cards according to Release 4.0.
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    check personal account rewards disclaimers

    [Teardown]    Log Out myBranch

Manage Rewards - Total Cash Back Disclaimer for Debit Card
    [Documentation]    Test to Verify the Total Cash Back disclaimer shows correctly for debit cards according to Release 4.0.
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    check personal account rewards disclaimers

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards CashBack Details Modal Dialog Displays Correctly
    [Documentation]    Test to make sure Rewards CashBack Details Modal Dialog Displays Correctly
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    RewardsCredit_Disclaimer_Link
    Exists    RewardsPointsDetails_Table
    Assert Page Contains    Rewards Program Details
    Assert Page Contains    Cash Back Program Features
    Click On    RewardsPointsDetails_Table_Close

    [Teardown]    Log Out myBranch


Manage Rewards - Rewards Link Work Correctly When Enrolled in Points
    [Documentation]  Test to check left navigation “My Rewards” link appears and navigates the user to the My Rewards page
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Exists    Manage Rewards
    Click On    Manage Rewards
    check if my rewards page is loaded

    [Teardown]    Log Out myBranch

Manage Rewards - Rewards Link Work Correctly When Enrolled in CashBack
    [Documentation]  Test to check left navigation “My Rewards” link appears and navigates the user to the My Rewards page
    [Tags]    new_test    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Exists    Manage Rewards
    Click On    Manage Rewards
    check if my rewards page is loaded

    [Teardown]    Log Out myBranch