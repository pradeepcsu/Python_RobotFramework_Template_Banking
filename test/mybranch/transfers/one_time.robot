*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           Host
Library           MyBranch
Resource          ../mybranch_keywords.robot

*** Keywords ***
    

*** Test Cases ***

One-Time Transfer - LOC to Classic Checking
    [Documentation]    UFT test case: 'Transfers - OneTime - LOC To ClassicChecking'
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.05}

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_LOC_PrincipalBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_LOC_PrincipalBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} + ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi6

    Verify Currency In Host    AccountDetails_LOC_PrincipalBalance    imi6_principal
    Verify Currency In Host    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    Verify Currency In Host    AccountDetails_LOC_AvailableCredit    imi6_availBalance
    Verify Currency In Host    AccountDetails_LOC_CreditLimit    imi6_creditLimit
    Verify Currency In Host    AccountDetails_LOC_DailyInterestAmount    imi6_dlyFinChrg
    Verify Currency In Host    AccountDetails_LOC_CurrentYearInterestPaid    imi6_ytdFinChrg
    Verify Currency In Host    AccountDetails_LOC_PriorYearInterestPaid    imi6_prevYtdFinChrg

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to    balance_from
    ...           cur_balance_from    cur_balance_to    AccountDetails_LOC_PrincipalBalance    imi6_principal
    ...           AccountDetails_LOC_PayoffAmount    imi6_payoffAmt    AccountDetails_LOC_AvailableCredit
    ...           imi6_availBalance    AccountDetails_LOC_CreditLimit    imi6_creditLimit    AccountDetails_LOC_DailyInterestAmount
    ...           imi6_dlyFinChrg    AccountDetails_LOC_CurrentYearInterestPaid    imi6_ytdFinChrg
    ...           AccountDetails_LOC_PriorYearInterestPaid    imi6_prevYtdFinChrg    AccountDetails_IM_AvailableBalance    imi1_MemoBalance
    
    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to Checking
    [Documentation]    UFT test case: 'Transfers - OneTime - Savings To Checking'
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.05}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to    balance_from
    ...           cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch   

One-Time Transfer - Savings to CreditCard
    [Documentation]    UFT test case: 'Transfers - OneTime - Savings To CreditCard'
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.27}

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'

    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    save batch    tran_amount    balance_from    cur_balance_from    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to FutureBuilder CD
    [Documentation]    UFT test case: 'Transfers - OneTime - Savings To FutureBuilderCD'
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.12}

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_CD_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_CD_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    sti1
    Verify Currency In Host    AccountDetails_CD_CurrentBalance    sti1_CurrentBal
    Verify Currency In Host    AccountDetails_CD_AvailableBalance    sti1_MemoBal
    print host object value    sti1_MemoBal

    Go To Account Screen    ${toaccount_number}    sti2
    Verify Transfer CD Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance
    ...           AccountDetails_CD_CurrentBalance    sti1_CurrentBal    AccountDetails_CD_AvailableBalance
    ...           sti1_MemoBal    AccountDetails_IM_AvailableBalance    AccountDetails_CD_AvailableBalance

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings to HELOC
    [Documentation]    UFT test case: 'Transfers - OneTime - Savings To HELOC'
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.09}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_HELOC_PayoffAmount

    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_HELOC_PayoffAmount
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}

    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} - ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    Go To Account Screen    ${toaccount_number}    amai
    Verify Currency In Host    AccountDetails_HELOC_PayoffAmount    amai_Payoff

    Go To Account Screen    ${toaccount_number}    amhs
    Verify Transfer HELOC Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_HELOC_PayoffAmount
    ...           AccountDetails_IM_CurrentBalance    imi1_LedgerBal    AccountDetails_IM_AvailableBalance
    ...           imi1_MemoBalance    AccountDetails_HELOC_PayoffAmount    amai_Payoff

    #print web object value    AccountDetails_IM_CurrentBalance
    #print web object value    AccountDetails_IM_AvailableBalance
    #print web object value    AccountDetails_HELOC_PayoffAmount
    #print host object value    imi1_LedgerBal
    #print host object value    imi1_MemoBalance
    #print host object value    amai_Payoff

    [Teardown]    Log Out myBranch      

One-Time Transfer - LOC to Gold Checking
    [Documentation]    UFT test case: 'Transfers - OneTime - LOC To GoldChecking'
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    1.20
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_LOC_PrincipalBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    ${tran_amount}
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_LOC_PrincipalBalance
    ${tran_amount_number} =    convert to number    ${tran_amount}
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} + ${tran_amount_number}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount_number}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi6
    Verify Currency In Host    AccountDetails_LOC_PrincipalBalance    imi6_principal
    Verify Currency In Host    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    Verify Currency In Host    AccountDetails_LOC_AvailableCredit    imi6_availBalance
    Verify Currency In Host    AccountDetails_LOC_CreditLimit    imi6_creditLimit
    Verify Currency In Host    AccountDetails_LOC_DailyInterestAmount    imi6_dlyFinChrg
    Verify Currency In Host    AccountDetails_LOC_CurrentYearInterestPaid    imi6_ytdFinChrg
    Verify Currency In Host    AccountDetails_LOC_PriorYearInterestPaid    imi6_prevYtdFinChrg

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to    balance_from
    ...           cur_balance_from    cur_balance_to    AccountDetails_LOC_PrincipalBalance    imi6_principal
    ...           AccountDetails_LOC_PayoffAmount    imi6_payoffAmt    AccountDetails_LOC_AvailableCredit
    ...           imi6_availBalance    AccountDetails_LOC_CreditLimit    imi6_creditLimit    AccountDetails_LOC_DailyInterestAmount
    ...           imi6_dlyFinChrg    AccountDetails_LOC_CurrentYearInterestPaid    imi6_ytdFinChrg    AccountDetails_LOC_PriorYearInterestPaid
    ...           imi6_prevYtdFinChrg    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings To Savings
    [Documentation]    UFT test case: 'Transfers - OneTime - Savings To Savings'    
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.25}

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance
    
    [Teardown]    Log Out myBranch    

One-Time Transfer - Savings To MoneyMarket
    [Documentation]    UFT test case: 'Transfers - OneTime - Savings To MoneyMarket'    
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.08}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch
    
One-Time Transfer - Savings To LOC
    [Documentation]    UFT test case: 'Transfers - OneTime - Savings To LOC'    
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.05}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}

    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    ${prev_balance_to} =     Get Account Balance    AccountDetails_LOC_PayoffAmount

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_LOC_PayoffAmount
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} - ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi6
    Verify Currency In Host    AccountDetails_LOC_PrincipalBalance    imi6_principal
    Verify Currency In Host    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    Verify Currency In Host    AccountDetails_LOC_AvailableCredit    imi6_availBalance
    Verify Currency In Host    AccountDetails_LOC_CreditLimit    imi6_creditLimit

    save batch  tran_amount    balance_from    cur_balance_from    balance_to   cur_balance_to
    ...         AccountDetails_IM_CurrentBalance    imi1_LedgerBal    AccountDetails_IM_AvailableBalance
    ...         imi1_MemoBalance    AccountDetails_LOC_PrincipalBalance    imi6_principal
    ...         AccountDetails_LOC_PayoffAmount    imi6_payoffAmt    AccountDetails_LOC_AvailableCredit
    ...         imi6_availBalance    AccountDetails_LOC_CreditLimit    imi6_creditLimit

    #print web object value    AccountDetails_IM_CurrentBalance
    #print web object value    AccountDetails_IM_AvailableBalance
    #print web object value    AccountDetails_LOC_PrincipalBalance
    #print web object value    AccountDetails_LOC_PayoffAmount
    #print web object value    AccountDetails_LOC_AvailableCredit
    #print web object value    AccountDetails_LOC_CreditLimit

    #print host object value    imi1_LedgerBal
    #print host object value    imi1_MemoBalance
    #print host object value    imi6_principal
    #print host object value    imi6_payoffAmt
    #print host object value    imi6_availBalance
    #print host object value    imi6_creditLimit

    [Teardown]    Log Out myBranch

One-Time Transfer - Savings To Loan
    [Documentation]    UFT test case: 'Transfers - OneTime - Savings To Loan'   
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.05}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_Loan_PayoffAmount

    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_Loan_PayoffAmount
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} - ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    amai
    Verify Currency In Host    AccountDetails_Loan_PayoffAmount    amai_Payoff

    Go To Account Screen    ${toaccount_number}    amhs
    Verify Transfer AM Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to    balance_from
    ...           cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    ...           AccountDetails_IM_AvailableBalance    imi1_MemoBalance    AccountDetails_Loan_PayoffAmount    amai_Payoff
    
    [Teardown]    Log Out myBranch
    
One-Time Transfer - LOC To Savings
    [Documentation]    UFT test case: 'Transfers - OneTime - LOC To Savings'   
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.05}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_LOC_PayoffAmount
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_LOC_PayoffAmount
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} + ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi6
    Verify Currency In Host    AccountDetails_LOC_PrincipalBalance    imi6_principal
    Verify Currency In Host    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    Verify Currency In Host    AccountDetails_LOC_AvailableCredit    imi6_availBalance
    Verify Currency In Host    AccountDetails_LOC_CreditLimit    imi6_creditLimit

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_LOC_PrincipalBalance
    ...           imi6_principal    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    ...           AccountDetails_LOC_AvailableCredit    imi6_availBalance    AccountDetails_LOC_CreditLimit
    ...           imi6_creditLimit    AccountDetails_LOC_DailyInterestAmount    imi6_dlyFinChrg
    ...           AccountDetails_LOC_CurrentYearInterestPaid    imi6_ytdFinChrg    AccountDetails_LOC_PriorYearInterestPaid
    ...           imi6_prevYtdFinChrg    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch

One-Time Transfer - LOC To MoneyMarket
    [Documentation]    UFT test case: 'Transfers - OneTime - LOC To MoneyMarket'    
    [Tags]    qa_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.25}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_LOC_PrincipalBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next
    
    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit
    
    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_LOC_PrincipalBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} + ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}


    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi6
    Verify Currency In Host    AccountDetails_LOC_PrincipalBalance    imi6_principal
    Verify Currency In Host    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    Verify Currency In Host    AccountDetails_LOC_AvailableCredit    imi6_availBalance
    Verify Currency In Host    AccountDetails_LOC_CreditLimit    imi6_creditLimit

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_LOC_PrincipalBalance
    ...           imi6_principal    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    ...           AccountDetails_LOC_AvailableCredit    imi6_availBalance    AccountDetails_LOC_CreditLimit
    ...           imi6_creditLimit    AccountDetails_LOC_DailyInterestAmount    imi6_dlyFinChrg
    ...           AccountDetails_LOC_CurrentYearInterestPaid    imi6_ytdFinChrg    AccountDetails_LOC_PriorYearInterestPaid
    ...           imi6_prevYtdFinChrg    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch
    
One-Time Transfer - Checking to Savings
    [Documentation]    UFT test case: 'Transfers - Checking To Savings'
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.25}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Savings Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch

One-Time Transfer - Checking to Loan
    [Documentation]    UFT test case: 'Transfers - Checking To Loan'
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.25}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_Loan_PayoffAmount

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds will be credited immediately on the date(s) selected.
    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds will be credited immediately on the date(s) selected.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_Loan_PayoffAmount
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} - ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    ##UAT 2 only - last post date from host IMB0
    ## filter the date : from date as bcr date/last post date
    ##${from_date} =    Get Bcr Date
    #${from_date} =    Get Date    days_modify=-62
    #Enter Text    AccountDetails_fromDate    ${from_date}
    ##Enter Text    AccountDetails_fromDate    02/11/2016
    #Click On    AccountDetails_Filter

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance
    print web object value    AccountDetails_IM_CurrentBalance
    print host object value    imi1_LedgerBal
    print web object value    AccountDetails_IM_AvailableBalance
    print host object value    imi1_MemoBalance


    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    ##UAT 2 only - last post date from host IMB0
    ## filter the date : from date as bcr date/last post date
    ##${from_date} =    Get Bcr Date
    #${from_date} =    Get Date    days_modify=-62
    #Enter Text    AccountDetails_fromDate    ${from_date}
    ##Enter Text    AccountDetails_fromDate    02/11/2016
    #Click On    AccountDetails_Filter

    Go To Account Screen    ${toaccount_number}    amai
    Verify Currency In Host    AccountDetails_Loan_PayoffAmount    amai_Payoff
    print web object value    AccountDetails_Loan_PayoffAmount
    print host object value    amai_Payoff


    Go To Account Screen    ${toaccount_number}    amhs
    Verify Transfer AM Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance    AccountDetails_Loan_PayoffAmount    amai_Payoff

    [Teardown]    Log Out myBranch 
    
One-Time Transfer - Checking to Credit Card
    [Documentation]    UFT test case: 'Transfers - Checking To CreditCard'
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.27}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds will be applied to your credit card account immediately on the date(s) selected, but may take 2-3 business days to display in the account's transaction history.

    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds will be applied to your credit card account immediately on the date(s) selected, but may take 2-3 business days to display in the account's transaction history.


    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}

    ##UAT 2 only - last post date from host IMB0
    ## filter the date : from date as bcr date/last post date
    ##${from_date} =    Get Bcr Date
    #${from_date} =    Get Date    days_modify=-62
    #Enter Text    AccountDetails_fromDate    ${from_date}
    ##Enter Text    AccountDetails_fromDate    02/11/2016
    #Click On    AccountDetails_Filter

    ## Ignore the PENDING transactions. sort transactions by debit column
    #Click On    Transactions_Debit_Col_Header

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    save batch  tran_amount    balance_from    cur_balance_from    AccountDetails_IM_CurrentBalance
    ...         imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch
    
One-Time Transfer - Checking to LOC
    [Documentation]    UFT test case: 'Transfers - Checking To LOC'
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.05}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown   AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_LOC_PayoffAmount

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds will be credited immediately on the date(s) selected.

    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds will be credited immediately on the date(s) selected.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown     AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_LOC_PayoffAmount
    Select Kendo Dropdown     AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} - ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    ##UAT 2 only - last post date from host IMB0
    ## filter the date : from date as bcr date/last post date
    ##${from_date} =    Get Bcr Date
    #${from_date} =    Get Date    days_modify=-62
    #Enter Text    AccountDetails_fromDate    ${from_date}
    ##Enter Text    AccountDetails_fromDate    02/11/2016
    #Click On    AccountDetails_Filter

    Open TSSO
    #Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi6
    Verify Currency In Host    AccountDetails_LOC_PrincipalBalance    imi6_principal
    Verify Currency In Host    AccountDetails_LOC_PayoffAmount    imi6_payoffAmt
    Verify Currency In Host    AccountDetails_LOC_AvailableCredit    imi6_availBalance
    Verify Currency In Host    AccountDetails_LOC_CreditLimit    imi6_creditLimit

    save batch  tran_amount    balance_from    cur_balance_from    balance_to    cur_balance_to
    ...         AccountDetails_IM_CurrentBalance    imi1_LedgerBal    AccountDetails_IM_AvailableBalance
    ...         imi1_MemoBalance    AccountDetails_LOC_PrincipalBalance    imi6_principal
    ...         AccountDetails_LOC_PayoffAmount    imi6_payoffAmt    AccountDetails_LOC_AvailableCredit
    ...         imi6_availBalance    AccountDetails_LOC_CreditLimit    imi6_creditLimit

    #print web object value    AccountDetails_IM_CurrentBalance
    #print web object value    AccountDetails_IM_AvailableBalance
    #print web object value    AccountDetails_LOC_PrincipalBalance
    #print web object value    AccountDetails_LOC_PayoffAmount
    #print web object value    AccountDetails_LOC_AvailableCredit
    #print web object value    AccountDetails_LOC_CreditLimit

    #print host object value    imi1_LedgerBal
    #print host object value    imi1_MemoBalance
    #print host object value    imi6_principal
    #print host object value    imi6_payoffAmt
    #print host object value    imi6_availBalance
    #print host object value    imi6_creditLimit
    
    [Teardown]    Log Out myBranch
    
One-Time Transfer - MoneyMarket to Classic Checking
    [Documentation]    UFT test case: 'Transfers - MoneyMarket To ClassicChecking'    
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.08}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to    balance_from
    ...           cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    ...           AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch
    
One-Time Transfer - Checking to HELOC
    [Documentation]    UFT test case: 'Transfers - Checking To HELOC'
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.09}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_HELOC_PayoffAmount

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds will be credited immediately on the date(s) selected.

    Click On    Submit

    #Assert Page Contains    Confirmation
    #Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds will be credited immediately on the date(s) selected.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_HELOC_PayoffAmount
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} - ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    ##UAT 2 only - last post date from host IMB0
    ## filter the date : from date as bcr date/last post date
    ##${from_date} =    Get Bcr Date
    ##${from_date} =    Get Date    days_modify=-62
    ##Enter Text    AccountDetails_fromDate    ${from_date}
    #Enter Text    AccountDetails_fromDate    02/11/2016
    #Click On    AccountDetails_Filter
    ## Ignore the PENDING transactions. sort transactions by debit column
    ##Click On    Transactions_Debit_Col_Header
    #sleep    3

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    amai
    Verify Currency In Host    AccountDetails_HELOC_PayoffAmount    amai_Payoff

    Go To Account Screen    ${toaccount_number}    amhs
    Verify Transfer HELOC Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_HELOC_PayoffAmount
    ...           AccountDetails_IM_CurrentBalance    imi1_LedgerBal    AccountDetails_IM_AvailableBalance
    ...           imi1_MemoBalance    AccountDetails_HELOC_PayoffAmount    amai_Payoff

    #print web object value    AccountDetails_IM_CurrentBalance
    #print web object value    AccountDetails_IM_AvailableBalance
    #print web object value    AccountDetails_HELOC_PayoffAmount
    #print host object value    imi1_LedgerBal
    #print host object value    imi1_MemoBalance
    #print host object value    amai_Payoff

    [Teardown]    Log Out myBranch
    
One-Time Transfer - Checking to FutureBuilderCD
    [Documentation]    UFT test case: 'Transfers - Checking To FutureBuilderCD'
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.12}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_CD_AvailableBalance

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds will be deposited immediately on the date(s) selected.

    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds will be deposited immediately on the date(s) selected.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_CD_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    ##UAT 2 only - last post date from host IMB0
    ## filter the date : from date as bcr date/last post date
    ##${from_date} =    Get Bcr Date
    #${from_date} =    Get Date    days_modify=-62
    #Enter Text    AccountDetails_fromDate    ${from_date}
    ##Enter Text    AccountDetails_fromDate    02/11/2016
    #Click On    AccountDetails_Filter
    ## Ignore the PENDING transactions. sort transactions by debit column
    #Click On    Transactions_Debit_Col_Header

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    Go To Account Screen    ${toaccount_number}    sti1
    Verify Currency In Host    AccountDetails_CD_CurrentBalance    sti1_CurrentBal
    Verify Currency In Host    AccountDetails_CD_AvailableBalance    sti1_MemoBal

    Go To Account Screen    ${toaccount_number}    sti2
    Verify Transfer CD Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance
    ...           AccountDetails_CD_CurrentBalance    sti1_CurrentBal    AccountDetails_CD_AvailableBalance
    ...           sti1_MemoBal    AccountDetails_IM_AvailableBalance    AccountDetails_CD_AvailableBalance

    [Teardown]    Log Out myBranch

One-Time Transfer - Checking to MoneyMarket
    [Documentation]    UFT test case: 'Transfers - Checking To MoneyMarket'
    [Tags]    qa_suite    uat2_suite    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.08}

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${prev_balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Verify_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $1.08
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${fromaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${fromaccount_namenumber}
    ${balance_from} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_from} =     Evaluate    ${prev_balance_from} - ${tran_amount}
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    Should Be Equal As Numbers    ${balance_from}   ${cur_balance_from}
    Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Go To Account Screen    ${fromaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${fromaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}


    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    @AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch

One-Time Transfer - Checking to MoneyMarket1
    [Documentation]    UFT test case: 'Transfers - Checking To MoneyMarket'
    ...                Test to verify one-time transfer funds from valid checking account to valid money market account.
    ...                Also validates the transaction against the host.
    ...                Data conditions: Active myBranch enrolled member with valid money market account & checking account with sufficinet balance
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    View Account Details
    ${tran_amount} =    set variable    ${1.08}
    ${fromaccount_balance} =    get im account balance   ${fromaccount_namenumber}
    ${toaccount_balance} =    get im account balance   ${toaccount_namenumber}
    Begin Transfer Funds    ${fromaccount_namenumber}    ${toaccount_namenumber}    ${tran_amount}
    Click On    Next
    Verify Transfer Funds Information    ${fromaccount_namenumber}    ${toaccount_namenumber}    ${tran_amount}
    Click On    Submit
    Verify Transfer Funds Confirmation    ${fromaccount_namenumber}    ${toaccount_namenumber}    ${tran_amount}
    Navigate Account Details
    Get and Verify Post Transfer Checking and Money Market Account Balances    ${fromaccount_namenumber}    ${toaccount_namenumber}    ${tran_amount}    ${fromaccount_balance}    ${toaccount_balance}
    Open TSSO
    Verify Checking Account Details and Transactions Against Host    ${fromaccount_number}
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    Verify Money Market Account Details and Transactions Against Host    ${toaccount_number}
    save batch    tran_amount    prev_balance_from    prev_balance_to    balance_to
    ...           balance_from    cur_balance_from    cur_balance_to    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance
    [Teardown]    Log Out myBranch

One-Time Transfer - Verify Transfer - Edit to Make Changes
    [Documentation]    UFT test case: 'Transfers - Transfer Funds - One-Time - Verify Transfer - Edit To Make Changes'
    [Tags]    qa_suite    negative_test    one-time
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    ${tran_amount} =    set variable    ${1.25}
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    Click On    Transfers_Edit

    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${AccountToNewEdit}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'

    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${AccountToNewEdit}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${AccountToNewEdit}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.
    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${AccountToNewEdit}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${AccountToNewEdit}.
    #Expect Text Contains    Transfers_Confirmation_TransferSummary    Funds transferred between Security Service checking, savings, money market, and certificate accounts will be available immediately. Availability of funds may vary for other types of transfers.

    [Teardown]    Log Out myBranch

One-Time Transfer - Verify Account Balances - LOC
    [Documentation]    New Test added to verify the account balances after one-time transfer for LOC account.
     ...               AssertStringIs Obj(FilterTable).GetCellData(2, 6), strNewFromBal
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    ${tran_amount} =    set variable    ${1.25}
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.

    Click On    Transfers_Edit

    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${AccountToNewEdit}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'

    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${AccountToNewEdit}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${AccountToNewEdit}.
    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${AccountToNewEdit}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${AccountToNewEdit}.

    [Teardown]    Log Out myBranch

One-Time Transfer - ACH Checking to Checking
    [Documentation]    UFT test case: 'Transfers - OneTime - ACH To Checking'
    ...                Test to verify one-time transfer of funds from ACH acc to Checking account.
    [Tags]    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.05}

    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${prev_balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.
    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}
    Expect Text Contains    AccountDetails_Header    ${toaccount_namenumber}
    ${balance_to} =     Get Account Balance    AccountDetails_IM_AvailableBalance
    ${cur_balance_to} =     Evaluate    ${prev_balance_to} + ${tran_amount}
    # Should Be Equal As Numbers    ${balance_to}    ${cur_balance_to}

    Open TSSO

    Go To Account Screen    ${toaccount_number}    imi1
    Verify Currency In Host    AccountDetails_IM_CurrentBalance    imi1_LedgerBal
    Verify Currency In Host    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    Go To Account Screen    ${toaccount_number}    imi2
    Verify Transfer Checking Transactions Against Host

    save batch    tran_amount    prev_balance_to    balance_to    cur_balance_to    AccountDetails_IM_CurrentBalance
    ...           imi1_LedgerBal    AccountDetails_IM_AvailableBalance    imi1_MemoBalance

    [Teardown]    Log Out myBranch

One-Time Transfer - ACH Checking to Credit Card
    [Documentation]    UFT test case: 'Transfers - OneTime - ACH To Credit Card'
    [Tags]    qa_suite
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    ${tran_amount} =    set variable    ${1.27}

    Click On    Ribbon_Transfers_Payments

    Click On    LeftNav_Transfers_Transfer_Funds
    Select Aria List Item Containing    Transfers_FromAccount_DropDown    ${fromaccount_namenumber}
    Select Aria List Item Containing    Transfers_ToAccount_DropDown    ${toaccount_namenumber}
    Enter Aria Text    Transfers_Amount    '${tran_amount}'
    Radio Button Should Be Set To    IsRecurring    False
    Click On    Next

    Assert Page Contains    Verify Information
    Assert Page Contains    Please review your Transfer details and verify the information entered is correct.
    Expect Text Contains    Transfers_Verify_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Verify_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Verify_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Verify_Frequency    One-Time
    Expect Text Contains    Transfers_Verify_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.

    Click On    Submit

    Assert Page Contains    Confirmation
    Assert Page Contains    Transfer Details
    Expect Text Contains    Transfers_Confirmation_TransferFrom    ${fromaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_TransferTo    ${toaccount_namenumber}
    Expect Text Contains    Transfers_Confirmation_Amount    $${tran_amount}
    Expect Text Contains    Transfers_Confirmation_Frequency    One-Time
    Expect Text Contains    Transfers_Confirmation_TransferSummary    A one-time transfer of $${tran_amount} will be sent from ${fromaccount_namenumber} to ${toaccount_namenumber}.

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    Select Kendo Dropdown    AccountDetails_SelectAccount    ${toaccount_namenumber}

    [Teardown]    Log Out myBranch


