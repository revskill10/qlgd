/** @jsx React.DOM */


var ThanhTra = React.createClass({
  getInitialState: function(){
    return {data: [], loading: false}
  },
  componentDidMount: function(){    
    $('.input-append.date').datepicker({
      format: "dd/mm/yyyy",
      startDate: "13/1/2014",
      todayBtn: "linked",
        language: "vi",
        autoClose: true,
        todayHighlight: true
    });    
  },
  handleDate: function(){
    this.setState({loading: true});
    var date = this.refs.thoi_gian.getDOMNode().value;
    $.ajax({
      url: '/thanhtra/lich_trinh_giang_days',
      type: 'POST',
      data: {date: date},
      success: function(data){
        $('#foo').data('spinner').stop();        
        this.setState({data: data, loading: false});
      }.bind(this)
    });
  },
  componentDidUpdate: function(){
    if (this.state.loading === true){
      var opts = {
        lines: 15, // The number of lines to draw
        length: 40, // The length of each line
        width: 10, // The line thickness
        radius: 22, // The radius of the inner circle
        corners: 1, // Corner roundness (0..1)
        rotate: 38, // The rotation offset
        direction: 1, // 1: clockwise, -1: counterclockwise
        color: '#000', // #rgb or #rrggbb or array of colors
        speed: 1.7, // Rounds per second
        trail: 81, // Afterglow percentage
        shadow: true, // Whether to render a shadow
        hwaccel: true, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: 'auto', // Top position relative to parent in px
        left: 'auto' // Left position relative to parent in px
      };
      var target = document.getElementById('foo');
      var spinner = new Spinner(opts).spin(target);
      $(target).data('spinner', spinner);
    } else {
      $('.input-append.date').datepicker({
        format: "dd/mm/yyyy",
        startDate: "13/1/2014",
        todayBtn: "linked",
          language: "vi",
          autoClose: true,
          todayHighlight: true
      });   
    }
  },
  render: function(){
    var x = this.state.data.map(function(d, index){
      return <ThanhTraRow data={d} stt={index+1} color={index % 2 === 0 ? 'danger' : 'warning'} />
    });
    if (this.state.loading === false){
      return (
        <div>
          <div class="input-append date">
            <input ref="thoi_gian" type="text" class="span2" /><span class="add-on"><i class="icon-th"></i></span>
            <button class="btn btn-sm btn-primary" onClick={this.handleDate}>Chọn ngày</button>          
          </div>
          <div class="table-responsive">      
            <table class="table table-bordered">
              <colgroup>
                <col style={{width: "5%"}} />
                <col style={{width: "30%"}} />
                <col style={{width: "10%"}} />
                <col style={{width: "15%"}} />
                <col style={{width: "15%"}} />
                <col style={{width: "15%"}} />
                <col style={{width: "10%"}} />
              </colgroup>
              <thead>
                <tr class="success">
                  <td>Stt</td><td>Giờ học</td><td>Báo lỗi</td><td>Note 1</td><td>Note 2</td><td>Note 3</td><td>Thao tác</td>
                </tr>
              </thead>
              <tbody>
                {x}
              </tbody>
            </table>
          </div>
        </div>
      );
    } else {
      return (
        <div id="foo"></div>
      );
    }
    
  }
});

var ThanhTraRow = React.createClass({
  render: function(){
    return (
      <tr class={this.props.color}>
        <td>{this.props.stt}</td>
        <td><span dangerouslySetInnerHTML={{__html: this.props.data.info}} /></td>
        <td>{this.props.data.di_muon_alias}<br/>{this.props.data.ve_som_alias}<br/>{this.props.data.bo_tiet_alias}</td>
        <td>{this.props.data.note1}</td>
        <td>{this.props.data.note2}</td>
        <td>{this.props.data.note3}</td>
        <td>
          <button class="btn btn-sm btn-primary">Báo cáo</button>
        </td>
      </tr>
    );
  }
});