nebula_osquery:
  fifteen_min:
    - query_name: running_procs
      query: select p.name as process, p.pid as process_id, p.cmdline, p.cwd, p.on_disk, p.resident_size as mem_used, p.parent, g.groupname, u.username as user, p.path, h.md5, h.sha1, h.sha256 from processes as p left join users as u on p.uid=u.uid left join groups as g on p.gid=g.gid left join hash as h on p.path=h.path;
    - query_name: established_outbound
      query: select t.iso_8601 as _time, pos.family, h.*, ltrim(pos.local_address, ':f') as src, pos.local_port as src_port, pos.remote_port as dest_port, ltrim(remote_address, ':f') as dest, name, p.path as file_path, cmdline, pos.protocol, lp.protocol from process_open_sockets as pos join processes as p on p.pid=pos.pid left join time as t LEFT JOIN listening_ports as lp on lp.port=pos.local_port AND lp.protocol=pos.protocol LEFT JOIN hash as h on h.path=p.path where not remote_address='' and not remote_address='::' and not remote_address='0.0.0.0' and not remote_address='127.0.0.1' and port is NULL;
    - query_name: listening_procs
      query:  select t.iso_8601 as _time, h.md5 as md5, p.pid, name, ltrim(address, ':f') as address, port, p.path as file_path, cmdline, root, parent from listening_ports as lp JOIN processes as p on lp.pid=p.pid left JOIN time as t JOIN hash as h on h.path=p.path WHERE not address='127.0.0.1';
    - query_name: suid_binaries
      query: select sb.*, t.iso_8601 as _time from suid_bin as sb join time as t;
  hour:
    - query_name: crontab
      query: select c.*,t.iso_8601 as _time from crontab as c join time as t;
  day:
    - query_name: rpm_packages
      query: select rpm.*, t.iso_8601 from rpm_packages as rpm join time as t;
