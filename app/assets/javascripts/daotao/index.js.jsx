 /** @jsx React.DOM */

 //= require ./gheplop
 //= require ./duyetdangky
 //= require ./lopmonhoc
//= require ./calendar
 React.renderComponent(<GhepLop />, document.getElementById('gheplop'));
 React.renderComponent(<DuyetDangKy />, document.getElementById('duyetdangky'));
 React.renderComponent(<TaoLop />, document.getElementById('lop2'));
 React.renderComponent(<DaotaoCalendar />, document.getElementById('calendar2'));