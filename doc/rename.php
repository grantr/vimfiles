<?
$d = dir(".");
while (false !== ($entry = $d->read()))
{
    if (strpos($entry,'.txt') !== false && strpos($entry, 'php-php-') !== false)
        rename($entry, preg_replace('/^php-/', '', $entry));
}
