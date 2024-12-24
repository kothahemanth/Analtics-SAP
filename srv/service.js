const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {
    const PurchaseOrderAPI = await cds.connect.to("CE_PURCHASEORDER_0001");
    
    // this.on("READ", "PurchaseOrders", async (req) => {
    //     req.query.SELECT.columns = [
    //         { ref: ["PurchaseOrder"] },
    //         { ref: ["PurchaseOrderItem"] },
    //         { ref: ["PurchaseOrderItemText"] },
    //         { ref: ["Plant"] },
    //         { ref: ["Material"] },
    //         { ref: ["BaseUnit"] },
    //         { ref: ["OrderQuantity"] },
    //         { ref: ["StorageLocation"] },
    //         { ref: ["CompanyCode"] },
    //         { ref: ["TaxCode"] },
    //         { ref: ["ConsumptionTaxCtrlCode"] },
    //         { ref: ["OrderPriceUnit"] },
    //     ];
    //     try {
    //         return await PurchaseOrderAPI.run(req.query);
    //     } catch (error) {
    //         console.error("Error reading PurchaseOrders:", error);
    //         req.error(500, "Failed to fetch data from PurchaseOrders API");
    //     }
    // });

    this.on("READ", "PurchaseOrders", async (req) => {
        // Remove groupby from the query
        const { groupby, ...restQuery } = req.query.SELECT;
    
        // Update the SELECT query
        req.query.SELECT = {
            ...restQuery, // Ensure only the basic fields are queried
            columns: [
                { ref: ["PurchaseOrder"] },
                { ref: ["PurchaseOrderItem"] },
                { ref: ["PurchaseOrderItemText"] },
                { ref: ["Plant"] },
                { ref: ["Material"] },
                { ref: ["BaseUnit"] },
                { ref: ["OrderQuantity"] },
                { ref: ["StorageLocation"] },
                { ref: ["CompanyCode"] },
                { ref: ["TaxCode"] },
                { ref: ["ConsumptionTaxCtrlCode"] },
                { ref: ["OrderPriceUnit"] },
            ],
        };
    
        try {
            const data = await PurchaseOrderAPI.run(req.query);
    
            // Perform grouping logic in the CAP service if required
            if (groupby) {
                const groupedData = groupByFields(data, groupby);
                return groupedData;
            }
    
            return data;
        } catch (error) {
            console.error("Error reading PurchaseOrders:", error);
            req.error(500, "Failed to fetch data from PurchaseOrders API");
        }
    });
    
    // Helper function to group data locally
    function groupByFields(data, groupby) {
        // Implement grouping logic based on `groupby` fields
        const grouped = {};
        data.forEach((item) => {
            const key = groupby.map((field) => item[field]).join("-");
            if (!grouped[key]) grouped[key] = { ...item, aggregatedQuantity: 0 };
            grouped[key].aggregatedQuantity += item.OrderQuantity;
        });
        return Object.values(grouped);
    }
    
});