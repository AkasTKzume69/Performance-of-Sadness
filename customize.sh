set_permissions() {
  set_perm  $MODPATH/system/vendor/etc/msm_irqbalance.conf 0 0 0644
  set_perm  $MODPATH/system/vendor/etc/powerhint.json 0 0 0644
  set_perm  $MODPATH/system/vendor/etc/game-list.pos 0 0 0644
  set_perm  $MODPATH/system/vendor/bin/perf_profile.pos 0 0 0777
  set_perm  $MODPATH/system/vendor/bin/perf_profile_restore.pos 0 0 0777
}

SKIPUNZIP=1
unzip -qjo "$ZIPFILE" 'common/functions.sh' -d $TMPDIR >&2
. $TMPDIR/functions.sh
