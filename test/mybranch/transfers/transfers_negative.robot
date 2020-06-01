*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Keywords ***


*** Test Cases ***

Transfers - Loan Account Does Not Show in From Account Dropdown
    [Documentation]    UFT test case: 'Transfers - Verify the From Account Dropdown for Loan Account - Negative Test'
    [Tags]    qa_suite    negative_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    ${Result} =    Find Item In Aria List    Transfers_FromAccount_DropDown    ${from_account}
    Should Not Be True    ${Result}    
    [Teardown]    Log Out myBranch
   
Transfers - CD Account Does Not Show in From Account Dropdown
    [Documentation]    UFT test case: 'Transfers - Verify the From Account Dropdown for CD Account - Negative Test'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    ${Result} =    Find Item In Aria List    Transfers_FromAccount_DropDown    ${from_account}
    Should Not Be True    ${Result}    
    [Teardown]    Log Out myBranch
   
Transfers - Credit Card Account Does Not Show in From Account Dropdown
    [Documentation]    UFT test case: 'Transfers - Verify the From Account Dropdown for Credit Card Account - Negative Test'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    ${Result} =    Find Item In Aria List    Transfers_FromAccount_DropDown    ${account_from}
    Should Not Be True    ${Result}    
    [Teardown]    Log Out myBranch
   
Transfers - Future Builder CD Does Not Show in To Account Dropdown
    [Documentation]    UFT test case: 'Transfers - OneTime - LOC To FutureBuilder CD - NegativeTest'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    ${Result} =    Find Item In Aria List    Transfers_ToAccount_DropDown    ${toaccount_namenumber}}
    Should Not Be True    ${Result}    
    [Teardown]    Log Out myBranch

Transfers - Negative Test - LOC To Future Builder CD
    [Documentation]    UFT test case: ''
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    select aria list item containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    ${found} =    find item in aria list    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Should Not Be True    ${found}
    [Teardown]    Log Out myBranch
   
Transfers - Negative Test - LOC To Credit Card
    [Documentation]    UFT test case: 'Transfers - OneTime - LOC To CreditCard'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    select aria list item containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    ${found} =    find item in aria list    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Should Not Be True    ${found}
    [Teardown]    Log Out myBranch
    
Transfers - Negative Test - LOC To Loan
    [Documentation]    UFT test case: 'Transfers - OneTime - LOC To Loan'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    select aria list item containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    ${found} =    find item in aria list    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Should Not Be True    ${found}
    [Teardown]    Log Out myBranch

Transfers - OneTime - Field Requirements - Amount - Zero
    [Documentation]    UFT test case: 'Transfers - OneTime - Field Requirements - Amount - Zero'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    0.00
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    Expect Text Contains    Transfer_Amount_ErrorMessage    please enter an amount greater than  

    [Teardown]    Log Out myBranch
    
Transfers - OneTime - Field Requirements - Amount - SpecChar
    [Documentation]    UFT test case: 'Transfers - OneTime - Field Requirements - Amount - SpecChar'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    
    # transfer page
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    @@1
    Expect Text    Transfers_Amount    1

    #Radio Button Should Be Set To    IsRecurring    False
    #Click On    Next
    
    [Teardown]    Log Out myBranch
    
Transfers - OneTime - Field Requirements - Amount - MaxChar
    [Documentation]    UFT test case: 'Transfers - OneTime - Field Requirements - Amount - MaxChar'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    
    # transfer page
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    999999999.99
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    Expect Text Contains    Transfer_Amount_ErrorMessage    please enter an amount greater than


    [Teardown]    Log Out myBranch
    
Transfers - OneTime - Field Requirements - Amount - Blank
    [Documentation]    UFT test case: 'Transfers - OneTime - Field Requirements - Amount - Blank'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    
    # transfer page
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Element Should Not Be Visible    IsRecurring
    Capture Page Screenshot
    Element Should Not Be Visible    NextButton
    Capture Page Screenshot
    Log    Amount field is blank and set the transfer frequesncy & date section is not visible

    [Teardown]    Log Out myBranch
    
Transfers - OneTime - Field Requirements - Amount - Alpha
    [Documentation]    UFT test case: 'Transfers - OneTime - Field Requirements - Amount - Alpha'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    
    # transfer page
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    1-1@    
    Expect Text    Transfers_Amount    11
    
    [Teardown]    Log Out myBranch


Recurring Transfer - Savings to Loan - Bi-Weekly - Verify the Transfer Day and Date Matching
    [Documentation]    UFT test case: 'Transfers - Savings To Loan - Recurring - Bi-Weekly - Verify the Transfer Day and Date Matching'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    1.25
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Bi-Weekly
    #Select Aria List Item    Transfers_Day    Tuesday
    select kendo dropdown    Transfers_Day    Tuesday
    ${beginning_on} =     Get Date    days_modify=8
    Enter Aria Text    Transfers_Date    ${beginning_on}
    select kendo dropdown    Transfers_Occurrence_New    Number of Transfers
    Enter Aria Text    Transfers_NumberOfTransfers    5
    Click On    Next

    # verify page
    Expect Text Contains    Transfers_BeginningOn_ErrorMessage    Your Beginning On Date must match the day of the week your recurring transfer occurs (for a Tues., Oct. 1 transfer, select Tues. as the Transfer On Day).

    [Teardown]    Log Out myBranch

Recurring Transfer - Verify the Recurring Transfer Fields
    [Documentation]    UFT test case: 'Transfers - Transfer Funds - Verify the Recurring Transfer Fields'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments

    # transfer page
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    1.25
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Bi-Weekly
    select kendo dropdown    Transfers_Day    Tuesday
    ${beginning_on} =     Get Date    days_modify=8
    Enter Aria Text    Transfers_Date    ${beginning_on}
    select kendo dropdown    Transfers_Occurrence_New    Number of Transfers
    Enter Aria Text    Transfers_NumberOfTransfers    5
    Click On    Next

    [Teardown]    Log Out myBranch

Recurring Transfer - Savings to Loan - Monthly - NegativeTest
    [Documentation]    UFT test case: 'Transfers - Savings To Loan - Recurring - Monthly - Verify the Transfer Day and Date Matching'
    [Tags]    qa_suite    negative_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    1.25
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Monthly
    #Select Aria List Item    Transfers_Day    26th
    select kendo dropdown    Transfers_Day    26th

    ${beginning_on} =     Get Date    no_pad=True    days_modify=8
    Enter Aria Text    Transfers_Date    ${beginning_on}
    select kendo dropdown    Transfers_Occurrence_New    Number of Transfers
    Enter Aria Text    Transfers_NumberOfTransfers    5
    Click On    Next

    #Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $1.25
    Expect Text Contains    Transfers_Verify_Frequency    Recurring Monthly
    Expect Date    Transfers_Verify_TransferDate    ${beginning_on}
    Expect Text Contains    Transfers_Verify_TransferSummary    A recurring transfer of $1.25 will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Verify_TransferSummary    Recurring transfer will begin on ${beginning_on} and occur monthly on the 26th for 5 transfer(s).
    # Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately.

    Click On    Submit

    Expect Text Contains    Transfer_Monthly_ErrorMessage    The Repeat Date/Day and the Beginning On Date must match. Please adjust the dates and try again.

    [Teardown]    Log Out myBranch

Recurring Transfer - Savings to Loan - Weekly - NegativeTest
    [Documentation]    UFT test case: 'Transfers - Savings To Loan - Recurring - Weekly - Verify the Transfer Day and Date Matching'
    [Tags]    qa_suite    negative_test    uat2_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    1.25
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Weekly
    select kendo dropdown    Transfers_Day    Tuesday
    ${beginning_on} =     Get Date    no_pad=True    days_modify=8
    Enter Aria Text    Transfers_Date    ${beginning_on}
    select kendo dropdown    Transfers_Occurrence_New    Number of Transfers
    Enter Aria Text    Transfers_NumberOfTransfers    5
    Click On    Next

    Expect Text Contains    Transfer_NotMatchingDayDate_ErrorMessage    Your Beginning On Date must match the day of the week your recurring transfer occurs (for a Tues., Oct. 1 transfer, select Tues. as the Transfer On Day).

    [Teardown]    Log Out myBranch

