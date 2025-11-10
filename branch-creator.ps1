# Auswahl-Menü für Repository
function Show-RepoMenu {
    $choices = @('Free Designs', 'Melori', 'Melori Mgt.')
    $selection = $choices | Out-GridView -Title "Choose a Repository" -PassThru
    return $selection
}

# Auswahl-Menü für Branch-Typ und Abfrage des Branch-Namens
function Create-NewBranchName {
    $branchTypes = @('feature', 'bugfix', 'hotfix', 'release', 'experiment', 'refactor')
    $branchType = $branchTypes | Out-GridView -Title "Choose a Branch Type" -PassThru
    $branchName = Read-Host "What is the name of the Branch?" 
    $branchName = $branchName -replace ' ', '-'
    return "$branchType/$branchName"
}

# Pfad des Projekts basierend auf Repository-Auswahl
function Get-ProjectPath {
    $repo = Show-RepoMenu
    switch ($repo) {
        'Free Designs' { return "C:\Users\Alex\IdeaProjects\FDV2" }
        'Melori' { return "C:\Users\Alex\IdeaProjects\Melori" }
        'Melori Mgt.' { return "C:\Users\Alex\IdeaProjects\MeloriManagment" }
        default { return "" }
    }
}

# Hauptlogik
$projectPath = Get-ProjectPath
$newBranchName = Create-NewBranchName

$commands = @(
    "git switch -c $newBranchName",
    'git commit --allow-empty -m "Start work on the feature"',
    "git push origin -u $newBranchName",
    "git checkout dev",
    "gh pr create --base dev --head $newBranchName --title `"New PR`" --body `"# New PR`" --draft"
)

foreach ($cmd in $commands) {
    Write-Host "`n>>> Running: $cmd"
    Push-Location $projectPath
    Invoke-Expression $cmd
    Pop-Location
}