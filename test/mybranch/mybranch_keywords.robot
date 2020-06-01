*** Settings ***
Library           Selenium2Library
Library           MyBranch

*** Variables ***

${QA}    http://mybranch-qa.ssfcu.org
${UAT2}    http://web-uat.mybranchdev.org


*** Keywords ***
Open myBranch
    # [Arguments]    ${REGION}
    ${URL}    Set Variable If
    ...    "${REGION}" == "QA"    ${QA}
    ...    "${REGION}" == "UAT2"    ${UAT2}
    Set Global Variable    ${URL}
    # Set Global Variable    ${REMOTE_URL}
    # Log    remote url: ${REMOTE_URL}
    # Open Browser    ${URL}    ${BROWSER}    ${REMOTE_URL}
    # Load Browser
    # Log    ${browser}

Log In myBranch
    [Arguments]    ${username}    ${password}
    Load Browser
    Maximize Browser Window
    Enter Text    LogIn_UserID    ${username}
    Enter Text    LogIn_Password    ${password}
    Click On    LogIn_LogIn
    ${Error_Message} =     check exists    Account_Locked
    Run Keyword If    ${Error_Message} == ${True}    Fail    ${username}/${password} Account is Locked
    Enter Text    LogInSecurity_Answer    test
    Click On    LogIn_LogIn

Get Random Email
    ${new email} =    Get Random String    8
    ${new email} =    Catenate    SEPARATOR=    ${new email}    @ssfcu.org
    [Return]    ${new email}

Hide Account
    [Arguments]    ${account_namenumber}
    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    ${account_shown} =      Get Table Cell Value    Settings_AccountPreferences_Table    ${row_index}    5
    # if account is already hidden then exit
    return from keyword if    "${account_shown}" == "No"

    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    unset checkbox    Settings_HideAccount_Checkbox
    Click On    Settings_HideAccount_SaveButton

Show Account
    [Arguments]    ${account_namenumber}
    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    ${account_shown} =      Get Table Cell Value    Settings_AccountPreferences_Table    ${row_index}    5
    # if account is already shown then exit
    return from keyword if    "${account_shown}" == "Yes"

    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    set checkbox    Settings_HideAccount_Checkbox
    Click On    Settings_HideAccount_SaveButton

Go To Manage Alert Contact
    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlertContacts

Go To Add New Alert
    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlerts
    Click On    Alerts_AddNewAlert

view account details
    [Arguments]    ${account}
    go to account details
    #Select Aria List Item    AccountDetails_SelectAccount    ${account_namenumber}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${account}

go to account details
    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails

Overdraft Coverage Navigation
    Click On    Ribbon_Accounts
    Click On    LeftNav_OverdraftCoverage
    Click On    LeftNav_OverdraftCoverage_TransactionCoverage

check for max scheduled transfers exceeded error
    #${Error_Message} =     exists    MaxScheduledTransfers_Exceeded_9_Validation_Error
    ${Error_Message} =     check exists    Transfer_Monthly_ErrorMessage
    Log    ${Error_Message}
    Run Keyword If    ${Error_Message} == ${True}    fail    Maximum limit of 9 recurring transfers exceeded error. Exceeded the limit of 9 scheduled payments/transfers from this account.
    Sleep    3
    Capture Page Screenshot

check for manage rewards widget appear
    Assert Page Contains    Rewards Summary
    Assert Page Contains    Total Points
    Expect Text Contains    ManageRewards_AvailablePoints   Available Points1
    Assert Page Contains    Redeem
    Assert Page Contains    Total Cash Back
    Assert Page Contains    Credit Cards
    Expect Text Contains    ManageRewards_AvailableCashBack     Available Cash Back2
    Assert Page Contains    Debit Cards
    Assert Page Contains    Year-to-Date
    Assert Page Contains    View Details

check for manage rewards widget doesnt appear
    Assert Page Does Not Contain    Rewards Summary
    Assert Page Does Not Contain    Total Points
    Assert Page Does Not Contain    Redeem
    Assert Page Does Not Contain    Total Cash Back
    Assert Page Does Not Contain    Year-to-Date
    Assert Page Does Not Contain    Manage Rewards

check if my rewards page is loaded
    Assert Page Contains    My Rewards
    Assert Page Contains    Account
    Assert Page Contains    Reward Type
    Assert Page Contains    Rewards Earned
    Assert Page Contains    Redeem

check personal account rewards disclaimers
    Exists    Rewards_Points_Disclaimer
    Exists    Rewards_CashBack_Credit_Disclaimer
    Exists    Rewards_CashBack_Debit_Disclaimer
    Expect Text Contains    Rewards_Points_Disclaimer    1 Points balance is based on the total from the previous business day and may not reflect most recent purchases or redemptions. Rewards Points Details  Business rewards are not included in Rewards Points totals.  Note: To view your Business Rewards points, please enroll or log in to myBranch as a Business member.
    Expect Text    Rewards_CashBack_Credit_Disclaimer    2 Cash Back balance is based on previous day’s transactions. More recent transactions may not be reflected in the total amount. Cash Back Details
    Expect Text    Rewards_CashBack_Debit_Disclaimer    3Cash Back balance is based on previous day’s transactions. More recent transaction may not be reflected in the total amount. Not currently available for Business accounts. Cash Back Details

check commercial account rewards disclaimers
    Exists    Rewards_PointsDisclaimer_Commercial
    Exists    Rewards_CashBack_Credit_Disclaimer_Commercial

scroll page to location
    [Arguments]    ${x_location}    ${y_location}
    Execute Javascript    window.ScrollTo(${x_location}, ${y_location})

Get Random AddressLine1
    ${address line1 first} =     Get Random Number String    5
    ${address line1 last} =    Set Variable    Address Line 1
    #${adress line1} =    Catenate    SEPARATOR=     ${address line1 first}         ${address line1 last}
    ${adress line1} =    Catenate    ${address line1 first}         ${address line1 last}
    Log    ${adress line1}
    [Return]    ${adress line1}

Get Random AddressLine2
    ${new addressline2} =    Get Random String    8
    [Return]    ${new addressline2}

Get Random MobilePhone
    ${new mobile} =    Get Random Digit
    [Return]    ${new mobile}

Get Random Mobile Number
    ${mobile number} =    Set Variable    55501005
    ${mobile number last} =    Get Random Number String    2
    ${mobile number} =    Catenate    SEPARATOR=    ${mobile number}    ${mobile number last}
    ${mobile number format} =    Get Mobile Number Format    ${mobile number}
    Log    ${mobile number format}
    [Return]    ${mobile number format}

