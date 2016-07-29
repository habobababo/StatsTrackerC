# StatsTrackerC

StatTrack DLC for https://github.com/habobababo/Database

run this in sql

CREATE TABLE IF NOT EXISTS `users` (
  `steamid` varchar(25) NOT NULL,
  `uid` varchar(26) NOT NULL,
  `steamid32` varchar(50) NOT NULL,
  `UG` varchar(25) NOT NULL,
  `NW` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
`cid` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4590 DEFAULT CHARSET=latin1;
