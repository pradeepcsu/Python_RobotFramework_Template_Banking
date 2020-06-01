*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Keywords ***
    

*** Test Cases ***

Recurring Transfer - Checking to Future Builder CD - Bi-Weekly
    [Documentation]    UFT test case: 'Transfers - Checking To FutureBuilderCD - BiWeekly'
    [Tags]    uat2_suite    recurring    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    ${tran_amount} =    Set Variable    1.25
    ${future_date} =    Get Random Future Date
    ${tran_date_no_zero_padding} =    Convert Date    ${future_date}
    ${tran_day} =    Get Day Of Date    ${future_date}
    Enter Aria Text    Transfers_Amount    ${tran_amount}
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Bi-Weekly
    select kendo dropdown    Transfers_Day    ${tran_day}

    Enter Aria Text    Transfers_Date    ${tran_date_no_zero_padding}
    select kendo dropdown    Transfers_Occurrence_New    Number of Transfers
    Enter Aria Text    Transfers_NumberOfTransfers    5
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    Recurring Bi-Weekly
    Expect Date    Transfers_Verify_TransferDate    ${tran_date_no_zero_padding}
    Expect Text Contains    Transfers_Verify_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Verify_TransferSummary    Recurring transfer will begin on ${tran_date_no_zero_padding} and occur every two weeks on ${tran_day} for 5 transfer(s).
    # Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately.
    Click On    Submit
    Sleep    1
    check for max scheduled transfers exceeded error

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    ${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    Recurring Bi-Weekly
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Confirmation_TransferSummary    Recurring transfer will begin on ${tran_date_no_zero_padding} and occur every two weeks on ${tran_day} for 5 transfer(s).
    # Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately.
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_ManagerTransfers
    # this needs to wait for grid to finish loading
    # otherwise it returns rowcount of 1
    Assert Page Contains    Manage Scheduled Transfers/Payments

    ${row} =    Get Table Row Count    Transfers_Recurring
    Log    ${row}
    Expect Date In Table Cell    Transfers_Recurring    ${row}    1    ${tran_date_no_zero_padding}
    Expect Text In Table Cell    Transfers_Recurring    ${row}    2    ${fromaccount_namenumber}
    # Expect Text In Table Cell    Transfers_Recurring    ${row}    3    ${toaccount_namenumber}
    Expect Text In Table Cell    Transfers_Recurring    ${row}    4    Bi-Weekly
    Expect Text In Table Cell    Transfers_Recurring    ${row}    5    ${Tran_Day}
    Expect Text In Table Cell    Transfers_Recurring    ${row}    6    $${tran_amount}
    Expect Text In Table Cell    Transfers_Recurring    ${row}    7    5
    Click Delete Recurring Transfer    ${row}
    Click On    Transfers_DeleteTransfer_Delete
    Capture Page Screenshot
    Click On    Transfers_DeleteTransfer_Close

    [Teardown]    Log Out myBranch

Recurring Transfer - Checking to HELOC - Weekly
    [Documentation]    UFT test case: 'Transfers - Checking To HELOC Weekly'
    [Tags]    uat2_suite    recurring    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    ${tran_amount} =    Set Variable    1.25
    ${future_date} =    Get Random Future Date
    ${tran_date_no_zero_padding} =    Convert Date    ${future_date}
    ${tran_day} =    Get Day Of Date    ${future_date}
    Enter Aria Text    Transfers_Amount    ${tran_amount}
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Weekly
    # Select Aria List Item    Transfers_Day    ${tran_day}
    select kendo dropdown    Transfers_Day    ${tran_day}
    Enter Aria Text    Transfers_Date    ${tran_date_no_zero_padding}
    select kendo dropdown    Transfers_Occurrence_New    Until I Cancel
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    Recurring Weekly
    Expect Date    Transfers_Verify_TransferDate    ${tran_date_no_zero_padding}
    Expect Text Contains    Transfers_Verify_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Verify_TransferSummary    Recurring transfer will begin on ${tran_date_no_zero_padding} and occur every week on ${tran_day} until you cancel.
    Click On    Submit
    Sleep    1
    check for max scheduled transfers exceeded error


    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    Recurring Weekly
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_ManagerTransfers
    Assert Page Contains    Manage Scheduled Transfers/Payments

    ${row} =    Get Table Row Count    Transfers_Recurring
    Expect Date In Table Cell    Transfers_Recurring    ${row}    1    ${tran_date_no_zero_padding}
    Expect Text In Table Cell    Transfers_Recurring    ${row}    2    ${fromaccount_namenumber}
    Expect Text In Table Cell    Transfers_Recurring    ${row}    3    ${toaccount_namenumber}
    Expect Text In Table Cell    Transfers_Recurring    ${row}    4    Weekly
    Expect Text In Table Cell    Transfers_Recurring    ${row}    5    ${tran_day}
    Expect Text In Table Cell    Transfers_Recurring    ${row}    6    $${tran_amount}
    Expect Text In Table Cell    Transfers_Recurring    ${row}    7    Until I Cancel
    Click Delete Recurring Transfer    ${row}
    Click On    Transfers_DeleteTransfer_Delete
    Capture Page Screenshot
    Click On    Transfers_DeleteTransfer_Close

    [Teardown]    Log Out myBranch

Recurring Transfer - Checking to Money Market - Weekly
    [Documentation]    UFT test case: 'Transfers - Checking To MoneyMarket - Weekly'
    [Tags]    uat2_suite    recurring    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}

    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    ${tran_amount} =    Set Variable    1.25
    ${number_of_transfers} =    Set Variable    20
    ${future_date} =    Get Random Future Date
    ${tran_date_no_zero_padding} =    Convert Date    ${future_date}
    ${tran_day} =    Get Day Of Date    ${future_date}
    Log    ${tran_amount}
    Log    ${number_of_transfers}
    Log    ${future_date}
    Log    ${tran_date_no_zero_padding}
    Log    ${tran_day}
    Enter Aria Text    Transfers_Amount    ${tran_amount}
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Weekly
    select kendo dropdown    Transfers_Day    ${tran_day}
    Enter Aria Text    Transfers_Date    ${tran_date_no_zero_padding}
    Capture Page Screenshot
    select kendo dropdown    Transfers_Occurrence_New    Number of Transfers
    Enter Aria Text    Transfers_NumberOfTransfers    ${number_of_transfers}
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    Recurring Weekly
    Expect Date    Transfers_Verify_TransferDate    ${tran_date_no_zero_padding}
    Expect Text Contains    Transfers_Verify_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Verify_TransferSummary    Recurring transfer will begin on ${tran_date_no_zero_padding} and occur every week on ${tran_day} for ${number_of_transfers} transfer(s).
    Click On    Submit
    Sleep    1
    check for max scheduled transfers exceeded error


    Assert Page Contains    Confirmation
    #Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    Recurring Weekly
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Confirmation_TransferSummary    Recurring transfer will begin on ${tran_date_no_zero_padding} and occur every week on ${tran_day} for ${number_of_transfers} transfer(s).
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_ManagerTransfers
    Assert Page Contains    Manage Scheduled Transfers/Payments

    ${tran_date_zero_padding} =    Convert Date    ${future_date}    zero=True
    ${expected_values} =    create dictionary
    ...    Effective Date=${tran_date_zero_padding}
    ...    From=${fromaccount_namenumber}
    ...    To=${toaccount_namenumber}
    ...    Repeat=Weekly
    ...    Day/Date=${tran_day}
    ...    Amount=$${tran_amount}
    ...    Remaining=${number_of_transfers}
    ${row} =    find table row matching    Transfers_Recurring    ${expected_values}
    run keyword if    ${row} == ${0}    fail    transfer not found
    Click Delete Recurring Transfer    ${row}
    Click On    Transfers_DeleteTransfer_Delete
    Capture Page Screenshot
    Click On    Transfers_DeleteTransfer_Close

    [Teardown]    Log Out myBranch

Recurring Transfer - Savings to Loan - Monthly
    [Documentation]    UFT test case: 'Transfers - Savings To Loan - Monthly'
    [Tags]    recurring    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    ${tran_amount} =    Set Variable    1.25
    ${future_date} =    Get Random Future Date
    ${tran_date_no_zero_padding} =    Convert Date    ${future_date}
    ${tran_day} =    Get Day Number Of Date    ${future_date}
    Enter Aria Text    Transfers_Amount    ${tran_amount}
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Monthly
    #Select Aria List Item    Transfers_Day    ${tran_day}
    select kendo dropdown  transfer_on_day    ${tran_day}
    Enter Aria Text    Transfers_Date    ${tran_date_no_zero_padding}
    select kendo dropdown    Transfers_Occurrence_New    Until I Cancel
    Click On    Next

    #Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains   Transfers_Verify_Frequency    Recurring Monthly
    Expect Text    Transfers_Verify_TransferDate    ${tran_date_no_zero_padding}
    Expect Text Contains    Transfers_Verify_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Click On    Submit
    Sleep    1
    check for max scheduled transfers exceeded error


    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains   Transfers_Confirmation_Frequency    Recurring Monthly
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Confirmation_TransferSummary    Recurring transfer will begin on ${tran_date_no_zero_padding} and occur monthly on the ${tran_day} until you cancel.
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_ManagerTransfers
    Assert Page Contains    Manage Scheduled Transfers/Payments

    ${tran_date_zero_padding} =    Convert Date    ${future_date}    zero=True
    ${expected_values} =    create dictionary
    ...    Effective Date=${tran_date_zero_padding}
    ...    From=${fromaccount_namenumber}
    ...    To=${toaccount_namenumber}
    ...    Repeat=Monthly
    ...    Day/Date=${tran_day}
    ...    Amount=$${tran_amount}
    ...    Remaining=Until I Cancel
    ${row} =    find table row matching    Transfers_Recurring    ${expected_values}
    run keyword if    ${row} == ${0}    fail    transfer not found
    Click Delete Recurring Transfer    ${row}
    Click On    Transfers_DeleteTransfer_Delete
    Capture Page Screenshot
    Click On    Transfers_DeleteTransfer_Close

    [Teardown]    Log Out myBranch

Recurring Transfer - Savings to Business LOC - Monthly
    [Documentation]    UFT test case: 'Transfers - Savings To BusinessLOC - Monthly'
    [Tags]    recurring    uat2_suite    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    ${tran_amount} =    Set Variable    1.25
    ${number_of_transfers} =    Set Variable    2
    ${future_date} =    Get Random Future Date
    ${tran_date_no_zero_padding} =    Convert Date    ${future_date}
    ${tran_day} =    Get Day Number Of Date    ${future_date}
    Enter Aria Text    Transfers_Amount    ${tran_amount}
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Monthly
    #Select Aria List Item    Transfers_Day    ${tran_day}
    select kendo dropdown    Transfers_Day    ${tran_day}
    Enter Aria Text    Transfers_Date    ${tran_date_no_zero_padding}
    select kendo dropdown    Transfers_Occurrence_New    Number of Transfers
    Enter Aria Text    Transfers_NumberOfTransfers    ${number_of_transfers}
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    Recurring Monthly
    Expect Date    Transfers_Verify_TransferDate    ${tran_date_no_zero_padding}
    Expect Text Contains    Transfers_Verify_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Verify_TransferSummary    Recurring transfer will begin on ${tran_date_no_zero_padding} and occur monthly on the ${tran_day} for ${number_of_transfers} transfer(s).
    Click On    Submit
    Sleep    1
    check for max scheduled transfers exceeded error


    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    Recurring Monthly
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Confirmation_TransferSummary    Recurring transfer will begin on ${tran_date_no_zero_padding} and occur monthly on the ${tran_day} for ${number_of_transfers} transfer(s).
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_ManagerTransfers
    Assert Page Contains    Manage Scheduled Transfers/Payments
    ${tran_date_zero_padding} =    Convert Date    ${future_date}    zero=True
    ${expected_values} =    create dictionary
    ...    Effective Date=${tran_date_zero_padding}
    ...    From=${fromaccount_namenumber}
    ...    To=${toaccount_namenumber}
    ...    Repeat=Monthly
    ...    Day/Date=${tran_day}
    ...    Amount=$${tran_amount}
    ...    Remaining=${number_of_transfers}
    ${row} =    find table row matching    Transfers_Recurring    ${expected_values}
    run keyword if    ${row} == ${0}    fail    transfer not found
    Click Delete Recurring Transfer    ${row}
    Click On    Transfers_DeleteTransfer_Delete
    Capture Page Screenshot
    Click On    Transfers_DeleteTransfer_Close

    [Teardown]    Log Out myBranch

Recurring Transfer - On a Non Business Day - Monthly
    [Documentation]    UFT test case: ' Transfers - Transfer Funds - Monthly - On a Non Business Day'
    ...    We scheduled the transfer to occur on Christmas.
    [Tags]    recurring    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}

    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    ${tran_amount} =    Set Variable    1.01
    Enter Aria Text    Transfers_Amount    ${tran_amount}
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Monthly
    pause testing
    #Select Aria List Item    Transfers_Day    25th
    select kendo dropdown    Transfers_Day    25th

    select kendo dropdown    Transfers_Occurrence_New    Until I Cancel
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    Recurring Monthly
    # Expect Date    Transfers_Verify_TransferDate    12/25/2016
    Expect Text Contains    Transfers_Verify_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    # Expect Text Contains    Transfers_Verify_TransferSummary    Recurring transfer will begin on 12/25/2016 and occur monthly on the 25th until you cancel.
    Click On    Submit
    Sleep    1
    check for max scheduled transfers exceeded error

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    Recurring Monthly
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A recurring transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    # Expect Text Contains    Transfers_Confirmation_TransferSummary    Recurring transfer will begin on 12/25/2016 and occur monthly on the 25th until you cancel.
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_ManagerTransfers
    Assert Page Contains    Manage Scheduled Transfers/Payments
    &{expected_values} =    create dictionary
    ...    From=${fromaccount_namenumber}
    ...    To=${toaccount_namenumber}
    ...    Repeat=Monthly
    ...    Amount=$${tran_amount}
    ...    Remaining=Until I Cancel
    ${row} =    find table row matching    Transfers_Recurring    ${expected_values}
    run keyword if    ${row} == ${0}    fail    transfer not found
    Click Delete Recurring Transfer    ${row}
    Click On    Transfers_DeleteTransfer_Delete
    Capture Page Screenshot
    Click On    Transfers_DeleteTransfer_Close

    [Teardown]    Log Out myBranch

Recurring Transfer - Add then Edit with Changes
    [Documentation]    UFT test case: 'Transfers - Transfer Funds - Recurring - Verify Transfer - Edit To Make Changes'
    [Tags]    recurring    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}

    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    ${tran_amount_1} =    Set Variable    1.23
    ${number_of_transfers_1} =    set variable    4
    ${beginning_on_1} =    Get Date    no_pad=True    days_modify=8
    Enter Aria Text    Transfers_Amount    ${tran_amount_1}
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Monthly
    # Select Aria List Item    Transfers_Day    26th
    select kendo dropdown    Transfers_Day    26th
    Enter Aria Text    Transfers_Date    ${beginning_on_1}
    select kendo dropdown    Transfers_Occurrence_New    Number of Transfers
    Enter Aria Text    Transfers_NumberOfTransfers    ${number_of_transfers_1}
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount_1}
    Expect Text Contains    Transfers_Verify_Frequency    Recurring Monthly
    Expect Date    Transfers_Verify_TransferDate    ${beginning_on_1}
    Expect Text Contains    Transfers_Verify_TransferSummary    A recurring transfer of $${tran_amount_1} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Expect Text Contains    Transfers_Verify_TransferSummary    Recurring transfer will begin on ${beginning_on_1} and occur monthly on the 26th for ${number_of_transfers_1} transfer(s).
    Click On    Transfers_Edit

    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber_edit}
    ${tran_amount_2} =    Set Variable    2.03
    ${number_of_transfers_2} =    set variable    7
    Enter Aria Text    Transfers_Amount    ${tran_amount_2}
    Radio Button Should Be Set To    IsRecurring    False
    Select Radio Option    IsRecurring    True
    Select Aria List Item    Transfers_Repeat    Monthly
    #Select Aria List Item    Transfers_Day    26th
    select kendo dropdown    Transfers_Day    26th
    ${beginning_on_2} =    Get Date    no_pad=True    days_modify=8
    Enter Aria Text    Transfers_Date    ${beginning_on_2}
    select kendo dropdown    Transfers_Occurrence_New    Number of Transfers
    Enter Aria Text    Transfers_NumberOfTransfers    ${number_of_transfers_2}
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber_edit}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount_2}
    Expect Text Contains    Transfers_Verify_Frequency    Recurring Monthly
    Expect Date    Transfers_Verify_TransferDate    ${beginning_on_2}
    Expect Text Contains    Transfers_Verify_TransferSummary    A recurring transfer of $${tran_amount_2} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber_edit}.
    Expect Text Contains    Transfers_Verify_TransferSummary    Recurring transfer will begin on ${beginning_on_2} and occur monthly on the 26th for ${number_of_transfers_2} transfer(s).
    Click On    Submit
    Sleep    1
    check for max scheduled transfers exceeded error

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber_edit}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount_2}
    Expect Text Contains    Transfers_Confirmation_Frequency    Recurring Monthly
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A recurring transfer of $${tran_amount_2} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber_edit}.
    Expect Text Contains    Transfers_Confirmation_TransferSummary    Recurring transfer will begin on ${beginning_on_2} and occur monthly on the 26th for ${number_of_transfers_2} transfer(s).
    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_ManagerTransfers

    Assert Page Contains    Manage Scheduled Transfers/Payments
    &{expected_values} =    create dictionary
    ...    From=${fromaccount_namenumber}
    ...    To=${toaccount_namenumber_edit}
    ...    Repeat=Monthly
    ...    Amount=$${tran_amount_2}
    ...    Remaining=${number_of_transfers_2}
    ${row} =    find table row matching    Transfers_Recurring    ${expected_values}
    run keyword if    ${row} == ${0}    fail    transfer not found
    Click Delete Recurring Transfer    ${row}
    Click On    Transfers_DeleteTransfer_Delete
    Capture Page Screenshot
    Click On    Transfers_DeleteTransfer_Close

    [Teardown]    Log Out myBranch





