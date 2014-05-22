Ext = window.Ext4 || window.Ext

Ext.require [
  'Rally.app.TimeboxScope'
  'Rally.data.wsapi.artifact.Store'
  'Rally.apps.iterationtrackingboard.statsbanner.IterationProgressDialog'
  'Rally.apps.iterationtrackingboard.statsbanner.iterationprogresscharts.CumulativeFlowChart'
]

describe 'Rally.apps.iterationtrackingboard.statsbanner.IterationProgressDialog', ->

  helpers
    createIterationProgressDialog: (config) ->
      Ext.create 'Rally.apps.iterationtrackingboard.statsbanner.IterationProgressDialog', Ext.apply(
        context: @createContext(true)
        store: Ext.create('Rally.data.wsapi.artifact.Store')
      , config)

    createContext: (withRecord = true) ->
      @iterationRecord = @mom.getRecord('iteration') if withRecord
      @context =
        getProject: -> Rally.environment.getContext().getProject()
        getTimeboxScope: =>
          Ext.create 'Rally.app.TimeboxScope', record: @iterationRecord

    stubWsapiCalls: ->
      @stories = @mom.getRecords('userstory', count: 4)

      @ajax.whenQuerying('artifact').respondWith(_.pluck(@stories, 'data'))
      @ajax.whenQuerying('Project').respondWith()

    stubSlmChartsCalls: ->
      projectOid = Rally.environment.getContext().getProject().ObjectID
      cumulativeFlowXMLData = "<chart >\n    <license>E1XXX3MEW9L.HSK5T4Q79KLYCK07EK</license>\n    <axis_category orientation=\"vertical_down\" size='9' color='000000' alpha='75' font='arial' bold='true' skip='0' />\n    <axis_value font=\"arial\" size=\"12\" color='000000'/>\n    <chart_grid_h alpha='20' color='000000' thickness='1' type='solid' />\n    <chart_border color='000000' top_thickness='0' bottom_thickness='0' left_thickness='0' right_thickness='0' />\n    <chart_data>\n            <row>\n                <null/>\n                    <string>Aug-19</string>\n                    <string>Aug-20</string>\n                    <string>Aug-23</string>\n                    <string>Aug-24</string>\n                    <string>Aug-25</string>\n            </row>\n            <row>\n                <!-- just an arbitrary cut off point for state names based on the fact that there can be six of them and they won't fit on the chart -->\n                <string>Released</string>\n                <number></number>\n                <number></number>\n                <number></number>\n                <number></number>\n                <number></number>\n            </row>\n            <row>\n                <!-- just an arbitrary cut off point for state names based on the fact that there can be six of them and they won't fit on the chart -->\n                <string>Accepted</string>\n                <number>0.0</number>\n                <number>0.0</number>\n                <number>0.0</number>\n                <number>0.0</number>\n                <number>2.1</number>\n            </row>\n            <row>\n                <!-- just an arbitrary cut off point for state names based on the fact that there can be six of them and they won't fit on the chart -->\n                <string>Completed</string>\n                <number>0.0</number>\n                <number>0.0</number>\n                <number>0.0</number>\n                <number>1.1</number>\n                <number>2.0</number>\n            </row>\n            <row>\n                <!-- just an arbitrary cut off point for state names based on the fact that there can be six of them and they won't fit on the chart -->\n                <string>In-Progress</string>\n                <number>0.0</number>\n                <number>0.0</number>\n                <number>4.0</number>\n                <number>6.45</number>\n                <number>4.0</number>\n            </row>\n            <row>\n                <!-- just an arbitrary cut off point for state names based on the fact that there can be six of them and they won't fit on the chart -->\n                <string>Defined</string>\n                <number>0.0</number>\n                <number>0.0</number>\n                <number>9.8</number>\n                <number>9.6</number>\n                <number>9.2</number>\n            </row>\n            <row>\n                <!-- just an arbitrary cut off point for state names based on the fact that there can be six of them and they won't fit on the chart -->\n                <string>Idea</string>\n                <number>0.0</number>\n                <number>0.0</number>\n                <number>0.1</number>\n                <number>0.0</number>\n                <number>0.0</number>\n            </row>\n        </chart_data>\n    <chart_rect x='63' y='40' width='525' height='300' positive_color='D2D8DD' positive_alpha='30' negative_color='D2D8DD' negative_alpha='10' />\n        <chart_type>stacked column</chart_type>\n    <chart_value prefix='' suffix='' decimals='0' separator='' position='cursor' hide_zero='true' as_percentage='false' font='arial' bold='true' size='18' color='ff0000' alpha='100' />\n    <!--<chart_transition type='dissolve' delay='0' duration='.05' order='category' />-->\n    <draw>\n      <text alpha='100' color='454545' bold='true' size='16' x='63' y='10' width='400' height='30' h_align='left' v_align='top'></text>\n        <text alpha='80' color='454545' size=\"12\" x=\"10\" y=\"240.0\" rotation='-90'>Plan Estimate</text>\n        <text alpha='80' color='454545' size=\"12\" x=\"305.5\" y=\"395\">Date</text>\n            <image x=\"566\" y=\"6\" width=\"24\" height=\"24\" url=\"http://localhost:80/slm/images/icon_help.jpg\"></image>\n        <image x=\"542\" y=\"10\" height=\"18\" width=\"20\" url=\"http://localhost:80/slm/images/icon_printer.jpg\"></image>\n    </draw>\n    <axis_value max=\"8\"/>\n    <link>\n        <area alt=\"Print\" x=\"542\" y=\"10\" height=\"18\" width=\"20\" target=\"print\"/>\n\n    </link>\n    <legend_label layout='horizontal' font='arial' bold='true' size='9' color='444466' alpha='90' />\n    <legend_rect margin=\"2\"  x='63' y='425' width='525' height='25'  positive_color='000000' positive_alpha='0'  />\n    <!--<legend_transition type='dissolve' delay='0' duration='1' />-->\n    <series_color>\n            <color>bca3db</color>\n            <color>76c10f</color>\n            <color>f5d100</color>\n            <color>026cfd</color>\n            <color>f8a010</color>\n            <color>8868b0</color>\n        </series_color>\n</chart>";
      burndownXMLData = "<chart >\n    <license>E1XXX3MEW9L.HSK5T4Q79KLYCK07EK</license>\n    <axis_category orientation=\"vertical_down\" size='9' color='000000' alpha='75' font='arial' bold='true' skip='0' />\n    <axis_value font=\"arial\" size=\"12\" color='026cfd'/>\n    <chart_grid_h alpha='20' color='000000' thickness='1' type='solid' />\n    <chart_border color='000000' top_thickness='0' bottom_thickness='0' left_thickness='0' right_thickness='0' />\n    <chart_data>\n            <row>\n                <null/>\n                    <string>Aug-19</string>\n                    <string>Aug-20</string>\n                    <string>Aug-23</string>\n                    <string>Aug-24</string>\n                    <string>Aug-25</string>\n            </row>\n            <row>\n                <string>To-Do</string>\n                    <number>0.0</number>\n                    <number>0.0</number>\n                    <number>0.0</number>\n                    <number>0.0</number>\n                    <number>11.5</number>\n            </row>\n            <row>\n                <string>Accepted</string>\n                    <number>0.0</number>\n                    <number>0.0</number>\n                    <number>0.0</number>\n                    <number>0.0</number>\n                    <number>4.2</number>\n            </row>\n            <row>\n                <string>Ideal Burndown</string>\n                    <number>16.0</number>\n                    <number>12.0</number>\n                    <number>8.0</number>\n                    <number>4.0</number>\n                    <number>0.0</number>\n            </row>\n        </chart_data>\n        <chart_value_text>\n            <row>\n                <null />\n                    <null />\n                    <null />\n                    <null />\n                    <null />\n                    <null />\n            </row>\n            <row>\n                <null />\n                    <number>0 Hours</number>\n                    <number>0 Hours</number>\n                    <number>0 Hours</number>\n                    <number>0 Hours</number>\n                    <number>11.5 Hours</number>\n            </row>\n            <row>\n                <null />\n                    <number>0 Points</number>\n                    <number>0 Points</number>\n                    <number>0 Points</number>\n                    <number>0 Points</number>\n                    <number>2.1 Points</number>\n            </row>\n            <row>\n                <null />\n                    <number>16 Hours</number>\n                    <number>12 Hours</number>\n                    <number>8 Hours</number>\n                    <number>4 Hours</number>\n                    <number>0 Hours</number>\n            </row>\n        </chart_value_text>\n    <chart_rect x='63' y='40' width='525' height='300' positive_color='D2D8DD' positive_alpha='30' negative_color='D2D8DD' negative_alpha='10' />\n    <chart_pref point_shape='circle' fill_shape='true' />\n        <chart_type>column</chart_type>\n    <chart_type>\n            <string>column</string>\n            <string>column</string>\n            <string>line</string>\n        </chart_type>\n    <chart_value prefix='' suffix='' decimals='0' separator='' position='cursor' hide_zero='true' as_percentage='false' font='arial' bold='true' size='18' color='ff0000' alpha='100' />\n    <!--<chart_transition type='dissolve' delay='0' duration='.05' order='category' />-->\n    <draw>\n <text alpha='100' color='454545' bold='true' size='16' x='63' y='10' width='400' height='30' h_align='left' v_align='top'>Iteration Burn Down</text>\n        <text alpha='80' color='454545' size=\"12\" x=\"10\" y=\"240.0\" rotation='-90'>To Do (Hours)</text>\n        <text alpha='80' color='454545' size=\"12\" x=\"305.5\" y=\"395\">Date</text>\n        <image x=\"566\" y=\"6\" width=\"24\" height=\"24\" url=\"http://localhost:80/slm/images/icon_help.jpg\"></image>\n        <image x=\"542\" y=\"10\" height=\"18\" width=\"20\" url=\"http://localhost:80/slm/images/icon_printer.jpg\"></image>\n                <text x=\"590\" y=\"333\" orientation=\"vertical_down\" size='12' color='76c10f' font='arial' bold='true'>0</text>\n                <text x=\"590\" y=\"258\" orientation=\"vertical_down\" size='12' color='76c10f' font='arial' bold='true'>2</text>\n                <text x=\"590\" y=\"183\" orientation=\"vertical_down\" size='12' color='76c10f' font='arial' bold='true'>4</text>\n                <text x=\"590\" y=\"108\" orientation=\"vertical_down\" size='12' color='76c10f' font='arial' bold='true'>6</text>\n                <text x=\"590\" y=\"33\" orientation=\"vertical_down\" size='12' color='76c10f' font='arial' bold='true'>8</text>\n            <text alpha='80' color='454545' size=\"12\" x=\"643\" y=\"120.0\" rotation='90'>Accepted (Points)</text>\n    </draw>\n    <axis_value max=\"16\"/>\n    <link>\n        <area alt=\"Print\" x=\"542\" y=\"10\" height=\"18\" width=\"20\" target=\"print\"/>\n\n    </link>\n    <legend_label layout='horizontal' font='arial' bold='true' size='9' color='444466' alpha='90' />\n    <legend_rect margin=\"2\"  x='63' y='425' width='525' height='25'  positive_color='000000' positive_alpha='0'  />\n    <!--<legend_transition type='dissolve' delay='0' duration='1' />-->\n    <series_color>\n            <color>026cfd</color>\n            <color>76c10f</color>\n            <color>00326f</color>\n    </series_color>\n</chart>";
      this.ajax.whenReadingEndpoint("/slm/charts/itsc.sp?sid=&iterationOid=1&cpoid=" + projectOid).respondWithHtml(burndownXMLData, {
        url: '/slm/charts/itsc.sp',
        method: 'GET'
      });
      this.ajax.whenReadingEndpoint("/slm/charts/icfc.sp?sid=&iterationOid=1&bigChart=true&cpoid=" + projectOid).respondWithHtml(cumulativeFlowXMLData, {
        url: '/slm/charts/icfc.sp',
        method: 'GET'
      });

  afterEach ->
    Rally.test.destroyComponentsOfQuery('statsbanneriterationprogressdialog')

  describe 'config:startingIndex', ->
    it 'should display the chosen chart', ->
      dialog = @createIterationProgressDialog(startingIndex: 2)
      @waitForVisible(css: '.rally-iteration-progress-cumulative-flow-chart').then ->
        expect(dialog.carousel.getCurrentItem().xtype).toBe 'statsbannercumulativeflowchart'
        button = Ext.DomQuery.selectNode('a.cumulativeflow')
        expect(button).toHaveCls('active')
