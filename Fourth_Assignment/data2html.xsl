<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Purpose of this xslt script is to create referenced tables over each restaurant section, which are related by common entities,
         so the readibility of the original data are more readable and get rid of unnecessary informations for making transformation
         as simple as possible for the end user.-->
    <xsl:output
            method="html"
            version="5.0"
            encoding="UTF-8"
            indent="yes"
            doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    />
    <!-- Variable used as a template for defining common table header.-->
    <xsl:variable name="commonTableHeader">
        <thead>
            <tr>
                <th>Warehouse ID</th>
                <th>Shift reference</th>
                <th>Lists of Equipment</th>
            </tr>
        </thead>
    </xsl:variable>
    <!-- This template is used for creating basic structure of the HTML document.-->
    <xsl:template match="/">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>
                    <xsl:value-of select="name(/*)"/>
                </title>
                <style>
                    h1.uppercase, h2.uppercase {
                    text-transform: uppercase;
                    }
                    .good-conditioned-equipment {
                    background-color: #5fe322;
                    }
                    .average-conditioned-equipment {
                    background-color: #ffd70d;
                    }
                    .bad-conditioned-equipment {
                    background-color: #ff4d4d;
                    }
                    table, th, td {
                    border: 1px solid black;
                    }
                    th, td {
                    padding: 20px;
                    }
                    .box{
                    width:20px;
                    height:20px;
                    }

                    .red {
                    background:#ff4d4d;
                    }
                    .green {
                    background:#5fe322;
                    }
                    .amber {
                    background:#ffd70d;
                    }
                    li.pointless {
                        list-style: none;
                    }
                </style>
            </head>
            <body>
                <xsl:apply-templates select="restaurant/kitchen" mode="overview"/>
                <xsl:apply-templates select="restaurant/pizza-corner" mode="overview"/>
                <xsl:apply-templates select="restaurant/bar"/>
                <xsl:apply-templates select="restaurant/guest-area"/>
                <xsl:call-template name="shifts"/>
                <xsl:call-template name="warehouses"/>
            </body>

        </html>
    </xsl:template>
    <!-- This template is used for creating table of all warehouses in the restaurant and displaying its basic information.-->
    <xsl:template name="warehouses">
        <xsl:variable name="warehouse">warehouse</xsl:variable>
        <xsl:call-template name="secondLevelHeading">
            <xsl:with-param name="sectionName" select="$warehouse"/>
        </xsl:call-template>
        <table>
            <xsl:attribute name="id">warehouses</xsl:attribute>
            <thead>
                <tr>
                    <th>Warehouse ID</th>
                    <th>Sanitary day</th>
                    <th>Responsible person</th>
                </tr>
            </thead>
            <tbody>
                <xsl:apply-templates select="restaurant/kitchen" mode="warehouseList"/>
                <xsl:apply-templates select="restaurant/pizza-corner" mode="warehouseList"/>
                <xsl:apply-templates select="restaurant/bar" mode="warehouseList"/>
            </tbody>
        </table>
    </xsl:template>
    <!-- This template is tend to list warehouse information for warehouses assigned to the bar.-->
    <xsl:template match="restaurant/bar" mode="warehouseList">
        <xsl:for-each select="./warehouse">
            <tr>
                <td><xsl:value-of select="@id"/></td>
                <td><xsl:value-of select="sanitary-day"/></td>
                <td><xsl:value-of select="responsible-person/name"/></td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <!-- This template is tend to list warehouse information for warehouses assigned to the kitchen.-->
    <xsl:template match="restaurant/pizza-corner" mode="warehouseList">
        <xsl:for-each select="./warehouses/warehouse">
            <tr>
                <td><xsl:value-of select="@id"/></td>
                <td><xsl:value-of select="sanitary-day"/></td>
                <td><xsl:value-of select="responsible-person/name"/></td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <!-- This template is tend to list warehouse information for warehouses assigned to the pizza-corner.-->
    <xsl:template match="restaurant/kitchen" mode="warehouseList">
        <xsl:for-each select="./warehouses/warehouse">
            <tr>
                <td><xsl:value-of select="@id"/></td>
                <td><xsl:value-of select="sanitary-day"/></td>
                <td><xsl:value-of select="responsible-person/name"/></td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <!-- This template is used for creating table of all shifts in the restaurant and displaying its basic information.-->
    <xsl:template name="shifts">
        <xsl:variable name="shiftsSection">shifts table</xsl:variable>
        <xsl:call-template name="secondLevelHeading">
            <xsl:with-param name="sectionName" select="$shiftsSection"/>
        </xsl:call-template>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Shift ID</th>
                    <th>Employees</th>
                </tr>
            </thead>
            <tbody>
                <xsl:attribute name="id">employees</xsl:attribute>
                <xsl:apply-templates select="restaurant/kitchen/shifts/shift"/>
                <xsl:apply-templates select="restaurant/bar/shifts/shift"/>
            </tbody>
        </table>
    </xsl:template>
    <!-- This template is tend to list shift information for shift assigned to the bar.-->
    <xsl:template match="restaurant/bar/shifts/shift">
        <xsl:variable name="actualRow" select="count(preceding-sibling::shift) + 3"/>
        <tr>
            <td>
                <xsl:value-of select="$actualRow"/>
            </td>
            <td>
                <xsl:value-of select="@shiftID"/>
            </td>
            <td>
                <ul>
                    <xsl:for-each select="employees/employee">
                        <li><xsl:value-of select="name/text()"/></li>
                    </xsl:for-each>
                </ul>
            </td>
        </tr>
    </xsl:template>
    <!-- This template is tend to list shift information for shift assigned to the kitchen.-->
    <xsl:template match="restaurant/kitchen/shifts/shift">
        <xsl:variable name="actualRow" select="count(preceding-sibling::shift) + 1"/>
            <tr>
                <td>
                    <xsl:value-of select="$actualRow"/>
                </td>
                <td>
                    <xsl:value-of select="@shiftID"/>
                </td>
                <td>
                    <ul>
                        <xsl:for-each select="employees/employee">
                            <li><xsl:value-of select="name/text()"/></li>
                        </xsl:for-each>
                    </ul>
                </td>
            </tr>
    </xsl:template>
    <!-- This template is used for printing color legend for actual condition of resstaurant equipment.-->
    <xsl:variable name="colorConditionLegend">
        <ul>
            <li>
                <xsl:attribute name="class">pointless</xsl:attribute>
                <div class="box green"/>Good condition of equipment.
            </li>
            <li>
                <xsl:attribute name="class">pointless</xsl:attribute>
                <div class="box amber"/>Average condition of equipment.
            </li>
            <li>
                <xsl:attribute name="class">pointless</xsl:attribute>
                <div class="box red"/>Bad condition of equipment.
            </li>
        </ul>
    </xsl:variable>
    <!-- Template used for defining overview table of bar main entities. -->
    <xsl:template match="restaurant/bar">
        <xsl:call-template name="mainHeader">
            <xsl:with-param name="sectionName" select="name(//bar)"/>
        </xsl:call-template>
        <table>
            <xsl:copy-of select="$commonTableHeader"/>
            <tbody>
                <tr>
                    <td>
                        <xsl:call-template name="entityLink">
                            <xsl:with-param name="entity" select="warehouse/attribute::id"/>
                        </xsl:call-template>
                    </td>
                    <td>
                        <xsl:call-template name="shiftIdListing">
                            <xsl:with-param name="shiftForSection" select="shifts/shift"/>
                        </xsl:call-template>
                    </td>
                    <td>
                        <xsl:call-template name="equipmentsList">
                            <xsl:with-param name="sectionsWithEquipment" select="list-of-equipment/equipment"/>
                        </xsl:call-template>
                    </td>
                </tr>
            </tbody>
        </table>
        <xsl:copy-of select="$colorConditionLegend"/>
    </xsl:template>
    <!-- Template used for defining overview table of pizza-corner main entities. -->
    <xsl:template match="restaurant/pizza-corner" mode="overview">
        <xsl:call-template name="mainHeader">
            <xsl:with-param name="sectionName" select="name(//pizza-corner)"/>
        </xsl:call-template>
        <table>
            <thead>
                <tr>
                    <th>Warehouse ID</th>
                    <th>Responsible person</th>
                    <th>List of equipment</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <xsl:call-template name="entityLink">
                            <xsl:with-param name="entity" select="//pizza-corner/warehouses/warehouse/attribute::id"/>
                        </xsl:call-template>
                    </td>
                    <td>
                        <xsl:call-template name="nameRef">
                            <xsl:with-param name="name" select="responsible-person/name"/>
                            <xsl:with-param name="shiftRef" select="responsible-person/shift-reference/attribute::shiftRef"/>
                        </xsl:call-template>
                    </td>
                    <td>
                        <xsl:call-template name="equipmentsList">
                            <xsl:with-param name="sectionsWithEquipment" select="list-of-equipment/equipment"/>
                        </xsl:call-template>
                    </td>
                </tr>
            </tbody>
        </table>
        <xsl:copy-of select="$colorConditionLegend"/>
    </xsl:template>
    <!-- Template used for create reference tag <a> pointing from one table to another by referencing to person's shift. -->
    <xsl:template name="nameRef">
        <xsl:param name="name"/>
        <xsl:param name="shiftRef"/>
        <xsl:element name="a">
            <xsl:attribute name="href">#employees</xsl:attribute>
            <xsl:value-of select="$name"/>
        </xsl:element>
    </xsl:template>
    <!-- Overwritten tamplate to create overview table over main kitchen entities. -->
    <xsl:template match="restaurant/kitchen" mode="overview">
        <xsl:call-template name="mainHeader">
            <xsl:with-param name="sectionName" select="name(//kitchen)"/>
        </xsl:call-template>
        <table>
            <xsl:copy-of select="$commonTableHeader"/>
            <tbody>
                <tr>
                    <td>
                        <xsl:call-template name="entityLink">
                            <xsl:with-param name="entity" select="//kitchen/warehouses/warehouse/attribute::id"/>
                        </xsl:call-template>
                    </td>
                    <td>
                        <xsl:call-template name="shiftIdListing">
                            <xsl:with-param name="shiftForSection" select="//kitchen/shifts/shift"/>
                        </xsl:call-template>
                    </td>
                    <td>
                        <xsl:call-template name="equipmentsList">
                            <xsl:with-param name="sectionsWithEquipment"
                                            select="//kitchen/list-of-equipment/equipment"/>
                        </xsl:call-template>
                    </td>
                </tr>
            </tbody>
        </table>
        <xsl:copy-of select="$colorConditionLegend"/>
    </xsl:template>
    <!-- Template used for create reference <a> tag for warehouses from one table to another.-->
    <xsl:template name="entityLink">
        <xsl:param name="entity"/>
        <xsl:element name="a">
            <xsl:attribute name="href">#warehouses</xsl:attribute>
            <xsl:value-of select="$entity"/>
        </xsl:element>
    </xsl:template>
    <!-- Template uesd for listing equipment for particular section. -->
    <xsl:template name="equipmentsList">
        <xsl:param name="sectionsWithEquipment"/>
        <xsl:for-each select="$sectionsWithEquipment">
            <xsl:choose>
                <xsl:when test="@condition='good'">
                    <xsl:call-template name="equipmentSpanColoring">
                        <xsl:with-param name="condition" select="@condition"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@condition='average'">
                    <xsl:call-template name="equipmentSpanColoring">
                        <xsl:with-param name="condition" select="@condition"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@condition='bad'">
                    <xsl:call-template name="equipmentSpanColoring">
                        <xsl:with-param name="condition" select="@condition"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="text()"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="position() != last()">
                <br/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <!-- This template is used for highlighting the condition with appropriate color background.-->
    <xsl:template name="equipmentSpanColoring">
        <xsl:param name="condition"/>
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:value-of select="concat($condition,'-conditioned-equipment')"/>
            </xsl:attribute>
            <xsl:value-of select="text()"/>
        </xsl:element>
    </xsl:template>
    <!-- Template applied whenewer is necessary to print list of shifts -->
    <xsl:template name="shiftIdListing">
        <xsl:param name="shiftForSection"/>
        <xsl:for-each select="$shiftForSection">
            <xsl:element name="a">
                <xsl:attribute name="href">#employees</xsl:attribute>
                <xsl:value-of select="./attribute::shiftID"/>
            </xsl:element>
            <xsl:if test="position() != last()">
                <br/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <!-- Overwritten template for defining structure of the table for Guest-Area section. -->
    <xsl:template match="restaurant/guest-area">
        <xsl:call-template name="mainHeader">
            <xsl:with-param name="sectionName" select="name(//guest-area)"/>
        </xsl:call-template>
        <table>
            <thead>
                <tr>
                    <th>Table ID</th>
                    <th>Capacity</th>
                    <th>Reserved places</th>
                </tr>
            </thead>
            <tbody>
                <xsl:call-template name="tableCapacityList">
                    <xsl:with-param name="actualNode" select="tables/table"/>
                </xsl:call-template>
            </tbody>
        </table>
    </xsl:template>
    <!-- Template for listing all tables in form of table with actual reserved places, its id and its capacity. -->
    <xsl:template name="tableCapacityList">
        <xsl:param name="actualNode"/>
        <xsl:for-each select="$actualNode">
            <tr>
                <td><xsl:value-of select="./attribute::tableID"/></td>
                <td><xsl:value-of select="./capacity"/></td>
                <td><xsl:value-of select="./occupancy-reserve"/></td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <!-- Capitalized heading for main section. -->
    <xsl:template name="mainHeader">
        <xsl:param name="sectionName"/>
        <xsl:element name="h1">
            <xsl:attribute name="class">
                uppercase
            </xsl:attribute>
            <xsl:value-of select="$sectionName"/>
        </xsl:element>
    </xsl:template>
    <!-- Capitalized heading for a subsection. -->
    <xsl:template name="secondLevelHeading">
        <xsl:param name="sectionName"/>
        <xsl:element name="h2">
            <xsl:attribute name="class">
                uppercase
            </xsl:attribute>
            <xsl:value-of select="$sectionName"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>