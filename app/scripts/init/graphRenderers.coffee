angular.module('neo4jApp.services')
.run([
  'GraphRenderer',
  'GraphStyle',
  (GraphRenderer, GraphStyle) ->

    noop = ->

    nodeOutline = new GraphRenderer.Renderer(
      onGraphChange: (selection) ->
        circles = selection.selectAll("circle.outline").data(
          (node) -> [node]
        )

        circles.enter()
        .append("circle")
        .classed('outline', true)
        .attr
          cx: 0
          cy: 0

        circles
        .attr
          r: (node) -> node.radius
          fill: (node) -> GraphStyle.forNode(node).get('fill')
          stroke: (node) -> GraphStyle.forNode(node).get('stroke')
          'stroke-width': (node) -> GraphStyle.forNode(node).get('stroke-width')

        circles.exit().remove()
      onTick: noop
    )

    nodeCaption = new GraphRenderer.Renderer(
      onGraphChange: (selection) ->
        text = selection.selectAll('text').data((node) -> node.caption)

        text.enter().append('text')
        .attr('text-anchor': 'middle')

        text
        .text((line) -> line.text)
        .attr("y", (line) -> line.baseline)
        .attr("fill": (line) -> GraphStyle.forNode(line.node).get('color'))

        text.exit().remove()

      onTick: noop
    )

    nodeOverlay = new GraphRenderer.Renderer(
      onGraphChange: (selection) ->
        circles = selection.selectAll('circle.overlay').data((node) ->
          if node.selected then [node] else []
        )

        circles.enter()
        .insert('circle', '.outline')
        .classed('ring', true)
        .classed('overlay', true)
        .attr
          cx: 0
          cy: 0
          fill: '#f5F6F6'
          stroke: 'rgba(151, 151, 151, 0.2)'
          'stroke-width': '3px'

        circles
        .attr
          r: (node) -> node.radius + 6

        circles.exit().remove()
      onTick: noop
    )

    arrowPath = new GraphRenderer.Renderer(
      onGraphChange: (selection) ->
        paths = selection.selectAll('path').data((rel) -> [rel])

        paths.enter().append('path')

        paths
        .attr('fill', (rel) -> GraphStyle.forRelationship(rel).get('fill'))
        .attr('stroke', 'none')

        paths.exit().remove()

      onTick: (selection) ->
        selection.selectAll('path')
        .attr('d', (d) -> d.arrowOutline)
        .attr('transform', (d) -> "translate(#{ d.startPoint.x } #{ d.startPoint.y }) rotate(#{ d.angle })")
    )

    relationshipType = new GraphRenderer.Renderer(
      onGraphChange: (selection) ->
        texts = selection.selectAll("text").data((rel) -> [rel])

        texts.enter().append("text")
        .attr("text-anchor": "middle")

        texts
        .text((rel) -> rel.type)

        texts.exit().remove()

      onTick: (selection) ->

        selection.selectAll('text')
        .attr('x', (d) -> d.midShaftPoint.x)
        .attr('y', (d) -> d.midShaftPoint.y + 4)
        .attr('transform', (d) -> "rotate(#{ d.textAngle } #{ d.midShaftPoint.x } #{ d.midShaftPoint.y })")
    )

    relationshipOverlay = new GraphRenderer.Renderer(
      onGraphChange: (selection) ->
        rects = selection.selectAll("rect").data((rel) -> [rel])

        band = 20

        rects.enter()
          .append('rect')
          .classed('overlay', true)
          .attr('fill', 'yellow')
          .attr('x', 0)
          .attr('y', -band / 2)
          .attr('height', band)

        rects
          .attr('opacity', (rel) -> if rel.selected then 0.3 else 0)

        rects.exit().remove()

      onTick: (selection) ->
        selection.selectAll('rect')
          .attr('width', (d) -> if d.arrowLength > 0 then d.arrowLength else 0)
          .attr('transform', (d) -> "translate(#{ d.startPoint.x } #{ d.startPoint.y }) rotate(#{ d.angle })")
    )

    GraphRenderer.nodeRenderers.push(nodeOutline)
    GraphRenderer.nodeRenderers.push(nodeCaption)
    GraphRenderer.nodeRenderers.push(nodeOverlay)
    GraphRenderer.relationshipRenderers.push(arrowPath)
    GraphRenderer.relationshipRenderers.push(relationshipType)
    GraphRenderer.relationshipRenderers.push(relationshipOverlay)
])
