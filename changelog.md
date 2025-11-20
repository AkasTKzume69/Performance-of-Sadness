<h2>Changelog</h2>

<section>
  <h3>V10-20251120</h3>
  <ul>
    <li>Switched to <strong>logcat (Event-Based) </strong> Game Detection (Extremely Optimized)</li>
    <li>Dropped logs from <code>/sdcard/Performance-of-Sadness.log</code></li>
    <li>Reduced CPU usage on Game Detection</li>
    <li>Improved start of Performance of Sadness service on every boot</li>
    <li>Major fixes to miscellaneous components and scripts</li>
    <li>Numerous under-the-hood optimizations and internal changes</li>
  </ul>
</section>

<section>
  <h3>V9-20251118</h3>
  <ul>
    <li>Introduced new Toast Notification for Performance of Sadness updates</li>
    <li>Added restore countdown for restoring profile</li>
    <li>Improved <strong>Performance of Sadness AI</strong> logic and efficiency</li>
    <li>Reduced delay when relaunching game</li>
    <li>Fixed Current Renderer blank on Performance-of-Sadness.log</li>
    <li>Fixed miscellaneous issues and script errors</li>
  </ul>
</section>

<section>
  <h3>V8 — 2025-11-17</h3>
  <ul>
    <li>Introduced the <strong>Dynamic Vulkan Pipeline Renderer Switch</strong> (applies only when a game is launched)</li>
    <li>Added new <strong>game-list.pof</strong> file (stores all supported games for Performance of Sadness AI)</li>
    <li>Added new <strong>Dalvik Hyperthreading</strong></li>
    <li>Added new <strong>pof_profile</strong> and <strong>pof_restore_profile</strong> scripts</li>
    <li>Improved <strong>Performance of Sadness AI</strong> logic and efficiency</li>
    <li>Enhanced <strong>GPU frequency tuning</strong> in <code>pof_profile</code></li>
    <li>Improved logging at <code>/sdcard/Performance-of-Sadness.log</code></li>
    <li>Fixed video color issue related to the Vulkan pipeline</li>
    <li>Fixed various miscellaneous issues and script errors</li>
    <li>Dropped deprecated scripts:
      <ul>
        <li><code>/vendor/bin/perf_profile.sh</code></li>
        <li><code>/vendor/bin/restore_perf_profile.sh</code></li>
      </ul>
    </li>
    <li>Numerous under-the-hood optimizations and internal changes</li>
  </ul>
</section>

<section>
  <h3>V7 — 2025-11-05</h3>
  <ul>
    <li>Minor fixes to miscellaneous components and scripts</li>
  </ul>
</section>

<section>
  <h3>V6 — 2025-11-04</h3>
  <ul>
    <li>Improved <strong>Performance of Sadness AI</strong></li>
    <li>Introduced <strong>Dynamic CPU Throttling</strong> (Zero CPU/RAM usage)</li>
    <li>Expanded game detection capabilities</li>
    <li>Added <strong>CPU/GPU tuning</strong> options</li>
    <li>Added <strong>Virtual Memory</strong> and RAM tuning</li>
    <li>Added <strong>I/O Scheduler tuning</strong></li>
    <li>Added <strong>Background Task Pressure Reduction</strong></li>
    <li>Reverted all <code>/vendor/etc/thermal*conf</code> files to stock</li>
    <li>Improved logging at <code>/sdcard/Performance-of-Sadness.log</code></li>
    <li>Fixed miscellaneous issues and script errors</li>
  </ul>
</section>

<section>
  <h3>V5 — 2025-11-03</h3>
  <ul>
    <li>Introduced redesigned <strong>Performance of Sadness AI</strong> (Zero CPU/RAM usage)</li>
    <li>Added new <code>/vendor/perf_profile.sh</code></li>
    <li>Added new <code>/vendor/restore_perf_profile.sh</code></li>
    <li>Introduced new logging system at <code>/sdcard/Performance-of-Sadness.log</code></li>
    <li>Switched globally to <strong>Vulkan renderthread backend pipeline</strong></li>
  </ul>
</section>

<section>
  <h3>V4 — 2025-11-02</h3>
  <ul>
    <li>Added new <strong>Touch Boost</strong> system property</li>
    <li>Introduced <code>/vendor/etc/msm_irqbalance.conf</code></li>
    <li>Added <code>mdss</code>, <code>smem-rpm</code>, <code>mpm</code>, <code>kgsl</code>, and <code>glink_lpass</code> entries</li>
  </ul>
</section>

<section>
  <h3>V3 — 2025-10-24</h3>
  <ul>
    <li>Added new <code>/vendor/etc/powerhint.json</code></li>
    <li>Increased aggressive <strong>Little Cluster minimum frequency</strong></li>
    <li>Increased aggressive <strong>Big Cluster minimum frequency</strong></li>
    <li>Increased aggressive <strong>GPU minimum frequency</strong></li>
    <li>Updated <strong>SUSTAINED_PERFORMANCE</strong> and <strong>INTERACTION</strong> CPU maximum frequencies</li>
    <li>Reverted multiple <code>/vendor/etc/thermal-*.conf</code> files back to stock</li>
  </ul>
</section>

<section>
  <h3>V2 — 2025-10-18</h3>
  <ul>
    <li>Removed multiple thermal configuration files, including:</li>
    <ul>
      <li><code>thermal-arvr.conf</code></li>
      <li><code>thermal-camera.conf</code></li>
      <li><code>thermal-class0.conf</code></li>
      <li><code>thermal-engine.conf</code></li>
      <li><code>thermal-extreme.conf</code></li>
      <li><code>thermal-high.conf</code></li>
      <li><code>thermal-map.conf</code></li>
      <li><code>thermal-mgame.conf</code></li>
      <li><code>thermal-nolimits.conf</code></li>
      <li><code>thermal-normal.conf</code></li>
      <li><code>thermal-phone.conf</code></li>
      <li><code>thermal-tgame.conf</code></li>
      <li><code>thermal-video.conf</code></li>
      <li><code>thermal-youtube.conf</code></li>
    </ul>
  </ul>
</section>

<section>
  <h3>V1 — 2025-10-17</h3>
  <ul>
    <li>Initial release</li>
  </ul>
</section>
