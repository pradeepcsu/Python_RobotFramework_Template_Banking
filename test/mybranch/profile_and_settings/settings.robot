*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../mybranch_keywords.robot

*** Variables ***
@{FAVORITES}    ManageFavorites_AccountSummaryCheckBox
        ...     ManageFavorites_DownloadTransactionsCheckBox
        ...     ManageFavorites_ViewStatementsCheckBox
        ...     ManageFavorites_RequestStatementCopyCheckBox
        ...     ManageFavorites_AccountDetailsCheckBox
        ...     ManageFavorites_ManageAlertContactsCheckBox
        ...     ManageFavorites_ManageAlertsCheckBox
        ...     ManageFavorites_ChangePasswordCheckBox
        ...     ManageFavorites_AccountPreferencesCheckBox
        ...     ManageFavorites_MyMessagesCheckBox
        ...     ManageFavorites_RequestCheckCopyCheckBox
        ...     ManageFavorites_ManageTransfersAndPaymentsCheckBox

*** Test Cases ***
My Favorites - Change and Verify
    [Documentation]    UFT test: "My Favorites - Manage Favorites"
    [Tags]    qa_suite    settings
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    log in mybranch    ${username}    ${password}

    click on    Ribbon_Profile_Settings
    click on    LeftNav_Settings_MyFavoritesMenu
    @{subset} =    get subset of    @{FAVORITES}
    :for    ${li}    in    @{subset}
    \    toggle checkbox    ${li}
    click on    Settings_MyFavoritesMenu_SaveButton
    assert page contains    Your favorites have been updated.

    @{items} =    get aria list items    MyFavorite_Listbox
    log many    @{items}

    verify favorites table displays correcty    Settings_MyFavoritesMenu_Table

   [Teardown]    Log Out myBranch
