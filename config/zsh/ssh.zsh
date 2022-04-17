
function _sshlist
{
    awk '/^Host [^\*]/{print $2}' ~/.ssh/config
}
