*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../mybranch_keywords.robot


*** Test Cases ***

RequestStopPayment - Batch
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPayment - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    RequestStopPayment
    log    ${Check_No}
    log    ${account_namenumber}

    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    ${List} =     exists    Support_RequestStopPaymentRange_SelectAccount
    Log    ${List}
    Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO

    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay
    ${stop_Pay}=  get field    imi1_StopPay
    Log    ${stop_Pay}
    Should Be Equal As Numbers    ${row_count}   ${stop_Pay}

    Go To Account Screen    ${account_number}    imi5
    take screenshot
    Verify request Stop Payment Single Check Against Host PostBatch
    Capture Page Screenshot
    take screenshot

    [Teardown]    Log Out myBranch

RequestStopPayment - Issued In Error - Batch
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPayment - IssuedInError - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    RequestStopPayment - Issued In Error
    log    ${Starting_CheckNo}
    log    ${Ending_CheckNo}
    log    ${account_namenumber}

    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    ${List} =     exists    Support_RequestStopPaymentRange_SelectAccount

    Log    ${List}
    Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO

    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay
    ${stop_Pay}=  get field    imi1_StopPay
    Log    ${stop_Pay}
    Should Be Equal As Numbers    ${row_count}   ${stop_Pay}

    Go To Account Screen    ${account_number}    imi5
    take screenshot
    Verify request Stop Payment Against Host
    Capture Page Screenshot
    take screenshot

    [Teardown]    Log Out myBranch

RequestStopPayment - Lost Or Stolen - Batch
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPayment - LostOrStolen - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    RequestStopPayment - Lost Or Stolen
    log    ${Starting_CheckNo}
    log    ${Ending_CheckNo}
    log    ${account_namenumber}

    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    ${List} =     exists    Support_RequestStopPaymentRange_SelectAccount

    Log    ${List}
    Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO

    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay
    ${stop_Pay}=  get field    imi1_StopPay
    Log    ${stop_Pay}
    Should Be Equal As Numbers    ${row_count}   ${stop_Pay}

    Go To Account Screen    ${account_number}    imi5
    click on    RequestStopPayment_RequestDate
    click on    RequestStopPayment_RequestDate
    take screenshot
    Verify request Stop Payment Against Host
    Capture Page Screenshot
    take screenshot

    [Teardown]    Log Out myBranch

RequestStopPayment - Wrong Address - Batch
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPayment_WrongAddress - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    RequestStopPayment - Wrong Address
    log    ${Starting_CheckNo}
    log    ${Ending_CheckNo}
    log    ${account_namenumber}

    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    ${List} =     exists    Support_RequestStopPaymentRange_SelectAccount

    Log    ${List}
    Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO

    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay
    ${stop_Pay}=  get field    imi1_StopPay
    Log    ${stop_Pay}
    Should Be Equal As Numbers    ${row_count}   ${stop_Pay}

    Go To Account Screen    ${account_number}    imi5
    take screenshot
    Verify request Stop Payment Against Host
    Capture Page Screenshot
    take screenshot

    [Teardown]    Log Out myBranch

RequestStopPayment - Range - Batch
    [Documentation]    UFT test: "Support - Account Inquiries - RequestStopPaymentRange - Batch"
    [Tags]    post_batch
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    load batch    RequestStopPayment - Range
    log    ${Starting_CheckNo}
    log    ${Ending_CheckNo}
    log    ${account_namenumber}

    Click On    Ribbon_Support
    Click On    LeftNav_Support_RequestStopPayment
    Assert Page Contains    Request Stop Payment

    #${List} =     exists    Support_RequestStopPaymentRange_SelectAccount
    ${List} =     check exists    Support_RequestStopPaymentRange_SelectAccount

    Log    ${List}
    Run Keyword If    ${List} == ${True}    Select Aria List Item    Support_RequestStopPaymentRange_SelectAccount    ${account_namenumber}
    Sleep    3
    Capture Page Screenshot

    ${row_count} =    Get Table Row Count    RequestStopPayment_TransactionsTable
    log    ${row_count}
    ${row} =     Evaluate    ${row_count} - 1
    log    ${row}

    Open TSSO

    Go To Account Screen    ${account_number}    imi1
    print host object value    imi1_StopPay
    ${stop_Pay}=  get field    imi1_StopPay
    Log    ${stop_Pay}
    Should Be Equal As Numbers    ${row_count}   ${stop_Pay}

    Go To Account Screen    ${account_number}    imi5
    take screenshot
    Verify request Stop Payment Against Host
    Capture Page Screenshot
    take screenshot

    [Teardown]    Log Out myBranch





