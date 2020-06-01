*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          mybranch_keywords.robot


*** Test Cases ***
Pre Batch
    [Documentation]    example pre batch script
    [Tags]    examples
    ${my_var} =  set variable  my_var variable value

    # this number variable will be converted to text when saved
    # when loaded, the test needs to convert back to number if needed
    ${number_var} =  set variable  ${3.45}

    save batch  my_var  number_var

Post Batch
    [Documentation]    example post batch script
    [Tags]    examples
    # give the name of the test that you want to get the pre batch variables from
    # in this case we're loading the batch vars for the above test, Pre Batch
    load batch  Pre Batch
    log  ${my_var}
    log  ${number_var}


testing
    Load Browser
    select kendo dropdown    Login_Destination_Dropdown    Profile
    Capture Page Screenshot

Test for Popup
    Load Browser
    Maximize Browser Window
    Enter Text    LogIn_UserID    2707302
    Enter Text    LogIn_Password    Testing1
    Log Source
    get source
    Click On    LogIn_LogIn