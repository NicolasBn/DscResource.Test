[Diagnostics.CodeAnalysis.SuppressMessageAttribute('DscResource.AnalyzerRules\Measure-ParameterBlockParameterAttribute', '', Scope='Function', Target='*')]
param (
    $ModuleName,
    $ModuleBase,
    $ModuleManifest,
    $ProjectPath,
    $SourceManifest
)

Describe 'Common Tests - Relative Path Length' -Tag 'Common Tests - Relative Path Length' {

    Context -Name 'When the resource should be used to compile a configuration in Azure Automation' {
        <#
            129 characters is the current maximum for a relative path to be
            able to compile configurations in Azure Automation.
        #>
        $fullPathHardLimit = 129
        $allModuleFiles = Get-ChildItem -Path $ModuleBase -Recurse

        $allModuleFiles = $allModuleFiles | Where-Object -FilterScript {
            # Skip all files under DscResource.Tests.
            $_.FullName -notmatch 'DscResource\.Tests'
        }

        $testCaseModuleFile = @()

        $allModuleFiles | ForEach-Object -Process {
            $testCaseModuleFile += @(
                @{
                    FullRelativePath = $_.FullName -replace ($moduleRootFilePath -replace '\\', '\\')
                }
            )
        }

        It 'The length of the relative full path <FullRelativePath> should not exceed the max hard limit' -TestCases $testCaseModuleFile {
            param
            (
                [Parameter()]
                [System.String]
                $FullRelativePath
            )

            $FullRelativePath.Length | Should -Not -BeGreaterThan $fullPathHardLimit
        }
    }
}
